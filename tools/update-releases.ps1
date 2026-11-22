# Adds a build to releases.json, applies the retention policy, regenerates the site and prints the commands
# the owner runs by hand. It never deletes anything and never talks to GitHub.
#
#   powershell -File tools/update-releases.ps1 -ApkName audio-agent-alpha-1.apk -Version alpha-1 [-Channel alpha|stable] [-Notes "text"]
#   powershell -File tools/update-releases.ps1 -PruneOnly          (only re-apply retention and regenerate)
#
# Retention: keep the newest N alpha builds (site/config.json "alphaKeep", default 3) and every stable build.
# The APK must already be in builds/ (tools/publish-public-build.ps1 in the app repo copies it there).
# Keep this file ASCII only.
param(
    [string]$ApkName,
    [string]$Version,
    [ValidateSet('alpha', 'stable')][string]$Channel = 'alpha',
    [string]$Notes = '',
    [string]$Date = '',
    [switch]$PruneOnly,
    [switch]$NoBuild
)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$config = [IO.File]::ReadAllText((Join-Path $Root 'site/config.json'), [Text.Encoding]::UTF8) | ConvertFrom-Json
$keepAlpha = 3
if ($config.alphaKeep) { $keepAlpha = [int]$config.alphaKeep }
$path = Join-Path $Root 'releases.json'

$list = New-Object System.Collections.ArrayList
if (Test-Path $path) {
    $j = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8) | ConvertFrom-Json
    foreach ($r in @($j.releases)) { if ($r) { [void]$list.Add($r) } }
}

$entry = $null
if (-not $PruneOnly) {
    if (-not $ApkName -or -not $Version) { throw 'Give -ApkName and -Version (or use -PruneOnly).' }
    if ($Version -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') { throw "Version may contain only letters, digits, '.', '_' and '-': $Version" }
    $file = Join-Path $Root (Join-Path 'builds' $ApkName)
    if (-not (Test-Path $file)) { throw "Not found: $file" }
    if (-not $Date) { $Date = (Get-Date).ToString('yyyy-MM-dd') }
    $tag = $Version
    if ($Version -match '^[0-9]') { $tag = "v$Version" }
    $entry = [pscustomobject]@{
        version = $Version
        tag     = $tag
        date    = $Date
        channel = $Channel
        file    = $ApkName
        sha256  = (Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash.ToLowerInvariant()
        size    = (Get-Item -LiteralPath $file).Length
        notes   = $Notes
    }
    # A re-publish of the same version replaces the old entry.
    for ($i = $list.Count - 1; $i -ge 0; $i--) { if ($list[$i].version -eq $Version) { $list.RemoveAt($i) } }
    $list.Insert(0, $entry)
}

# Retention: the list is ordered newest first.
$kept = New-Object System.Collections.ArrayList
$dropped = New-Object System.Collections.ArrayList
$alphaSeen = 0
foreach ($r in $list) {
    if ($r.channel -eq 'stable') { [void]$kept.Add($r); continue }
    $alphaSeen++
    if ($alphaSeen -le $keepAlpha) { [void]$kept.Add($r) } else { [void]$dropped.Add($r) }
}

function Json-Str($s) { return ([string]$s | ConvertTo-Json) }
$rows = foreach ($r in $kept) {
    "    {`n" +
    "      `"version`": $(Json-Str $r.version),`n" +
    "      `"tag`": $(Json-Str $r.tag),`n" +
    "      `"date`": $(Json-Str $r.date),`n" +
    "      `"channel`": $(Json-Str $r.channel),`n" +
    "      `"file`": $(Json-Str $r.file),`n" +
    "      `"sha256`": $(Json-Str $r.sha256),`n" +
    "      `"size`": $([int64]$r.size),`n" +
    "      `"notes`": $(Json-Str $r.notes)`n" +
    "    }"
}
$body = "{`n  `"releases`": ["
if ($kept.Count -gt 0) { $body += "`n" + ($rows -join ",`n") + "`n  " }
$body += "]`n}`n"
[IO.File]::WriteAllText($path, $body, $Utf8)
Write-Output "releases.json: $($kept.Count) kept, $($dropped.Count) dropped."

if (-not $NoBuild) { & (Join-Path $PSScriptRoot 'build-site.ps1') | Select-Object -First 1 }

if ($dropped.Count -gt 0) {
    Write-Output ''
    Write-Output 'Removed from releases.json by the retention policy. Nothing was deleted: delete these yourself.'
    Write-Output '  GitHub Releases (also deletes the tag):'
    foreach ($r in $dropped) { Write-Output "    gh release delete $($r.tag) --repo $($config.repo) --cleanup-tag --yes     # asset $($r.file)" }
    Write-Output '  Local copies in builds/ (not committed, optional):'
    foreach ($r in $dropped) { Write-Output "    builds/$($r.file)" }
}

if ($entry) {
    $title = "Audio Agent $($entry.version) ($($entry.channel))"
    $flag = '--prerelease'
    if ($entry.channel -eq 'stable') { $flag = '--latest' }
    $noteText = $entry.notes
    if (-not $noteText) { $noteText = "Audio Agent $($entry.version). SHA-256: $($entry.sha256)" } else { $noteText = "$noteText SHA-256: $($entry.sha256)" }
    $noteText = $noteText.Replace('"', "'")
    Write-Output ''
    Write-Output "SHA-256: $($entry.sha256)"
    Write-Output "Size:    $($entry.size) bytes"
    Write-Output ''
    Write-Output 'Next steps (you run these; nothing was pushed):'
    Write-Output "  1. gh release create $($entry.tag) builds/$($entry.file) --repo $($config.repo) --title `"$title`" --notes `"$noteText`" $flag"
    Write-Output "  2. git add -A; git commit -m `"Publish build $($entry.version)`"; git push"
}
