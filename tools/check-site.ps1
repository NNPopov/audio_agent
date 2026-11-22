# Structure check of the generated site. Exit code 1 when something is wrong.
#   powershell -File tools/check-site.ps1 [-Root <dir>]
# Checks per page: doctype, html lang, title, one h1, skip link target, main landmark, no third-party requests,
# internal links resolve, every language page links all languages, every home page links its policy,
# every policy page links its home page. Keep this file ASCII only.
param([string]$Root = '')
$ErrorActionPreference = 'Stop'
if (-not $Root) { $Root = Split-Path -Parent $PSScriptRoot }
$codes = @(Get-ChildItem (Join-Path $Root 'site/i18n') -Filter '*.json' | ForEach-Object { $_.BaseName })
$errors = New-Object System.Collections.ArrayList
function Fail($page, $msg) { [void]$errors.Add("${page}: $msg") }

$pages = @('index.html', 'privacy/index.html', 'terms/index.html')
foreach ($c in $codes) { $pages += "$c/index.html"; $pages += "privacy/$c/index.html"; $pages += "terms/$c/index.html" }

foreach ($p in $pages) {
    $full = Join-Path $Root $p
    if (-not (Test-Path $full)) { Fail $p 'missing'; continue }
    $h = [IO.File]::ReadAllText($full, [Text.Encoding]::UTF8)
    if ($h -notmatch '(?i)^<!doctype html>') { Fail $p 'no doctype' }
    if ($h -notmatch '<html lang="[a-z-]+"') { Fail $p 'no html lang' }
    if ($h -notmatch '<title>[^<]+</title>') { Fail $p 'no title' }
    if ([regex]::Matches($h, '<h1[ >]').Count -ne 1) { Fail $p 'expected exactly one h1' }
    if ($h -notmatch '<a class="skip" href="#main"' -or $h -notmatch 'id="main"') { Fail $p 'skip link or main target missing' }
    if ($h -notmatch '<main[ >]') { Fail $p 'no main landmark' }
    if ($h -notmatch 'name="viewport"') { Fail $p 'no viewport meta' }
    # Third-party requests: any src or stylesheet/script href to another host. (Plain <a href> to https links is fine.)
    if ($h -match '<(script|img|iframe|link|source|video|audio)\b[^>]*\b(src|href)="https?://') {
        if ($h -match '<(script|img|iframe|source|video|audio)\b[^>]*\bsrc="https?://' -or $h -match '<link\b[^>]*\bhref="https?://') { Fail $p 'loads a resource from another host' }
    }
    # Internal links
    $dir = Split-Path -Parent $full
    $hNoScript = [regex]::Replace($h, '(?s)<script.*?</script>', '')
    foreach ($m in [regex]::Matches($hNoScript, '(?:href|src)="([^"#]*)(#[^"]*)?"')) {
        $u = $m.Groups[1].Value
        if ($u -eq '' -or $u -match '^(https?:|mailto:|data:)') { continue }
        $target = Join-Path $dir $u
        if ($u.EndsWith('/') -or (Test-Path $target -PathType Container)) { $target = Join-Path $target 'index.html' }
        if (-not (Test-Path $target)) { Fail $p "broken link: $u" }
    }
    # Every page links Terms (own language) and License
    $tl = 'en'; if ($p -match '^(?:privacy/|terms/)?([a-z]{2,3})/index\.html$') { $tl = $Matches[1] }
    if ($h -notmatch ('<a href="[^"]*terms/' + $tl + '/">')) { Fail $p "no link to the Terms ($tl)" }
    if ($h -notmatch 'href="https://github\.com/[^"]+/blob/main/LICENSE"') { Fail $p 'no link to the License' }
    if ($p -match '^terms/([a-z]{2,3})/index\.html$') {
        if ($h -notmatch '<h2>') { Fail $p 'terms body missing' }
        if ($h -match '\*\*|\]\(|^\|') { Fail $p 'unconverted Markdown left in the terms' }
        if ($h -notmatch 'href="\.\./\.\./privacy/[a-z]{2,3}/"') { Fail $p 'terms do not link the privacy policy' }
    }
    if ($p -match '^(index|[a-z]{2,3}/index)\.html$' -and $h -notmatch 'id="download-h"[\s\S]*?href="[^"]*terms/[a-z]{2,3}/"[\s\S]*?id="latest-alpha"') { Fail $p 'download section lacks the Terms line' }
    # Language switch
    $isChooser = ($p -eq 'privacy/index.html' -or $p -eq 'terms/index.html')
    foreach ($c in $codes) {
        if ($h -notmatch ('<a href="[^"]*' + $c + '/" lang="' + $c + '" hreflang="' + $c + '"')) { Fail $p "does not link language $c" }
    }
    if ($isChooser -and $h -notmatch '<noscript>') { Fail $p 'chooser has no noscript' }
    if ($isChooser -and $h -notmatch 'location\.replace') { Fail $p 'chooser has no redirect script' }
    if ($isChooser) { foreach ($c in $codes) { if ($h -notmatch ('<noscript>[\s\S]*href="' + $c + '/"[\s\S]*</noscript>')) { Fail $p "noscript lacks $c" } } }
    # Home pages link their policy; policy pages link home and the English original (translations)
    if ($p -match '^([a-z]{2,3})/index\.html$' -and $h -notmatch ('href="\.\./privacy/' + $Matches[1] + '/"')) { Fail $p 'no link to its privacy policy' }
    if ($p -eq 'index.html' -and $h -notmatch 'href="privacy/en/"') { Fail $p 'no link to the privacy policy' }
    if ($p -match '^privacy/([a-z]{2,3})/index\.html$') {
        $c = $Matches[1]
        if ($h -notmatch ('href="\.\./\.\./' + $c + '/"')) { Fail $p 'no link back to its home page' }
        if ($c -ne 'en' -and $h -notmatch 'class="notice"') { Fail $p 'translation lacks the original-is-English notice' }
        if ($h -notmatch '<h2>') { Fail $p 'policy body missing' }
        if ($h -match '\*\*|\]\(|^\|') { Fail $p 'unconverted Markdown left in the policy' }
    }
    if ($p -match '^(index|[a-z]{2,3}/index)\.html$') {
        if ($h -notmatch 'class="alpha"') { Fail $p 'no alpha notice' }
        if ($h -notmatch 'id="download"') { Fail $p 'no download section' }
        if ($h -notmatch 'releases\.json') { Fail $p 'does not read releases.json' }
    }
}
foreach ($f in 'assets/style.css', '.nojekyll', 'releases.json') { if (-not (Test-Path (Join-Path $Root $f))) { Fail $f 'missing' } }
# No names or keys in tracked sources
$files = Get-ChildItem $Root -Recurse -File | Where-Object { $_.FullName -notmatch '[\\/](\.git|builds)[\\/]' }
foreach ($f in $files) {
    $t = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
    if ($t -match 'sk-[A-Za-z0-9]{20,}') { Fail $f.Name 'looks like an API key' }
    if ($f.Name -notin 'check-site.ps1', 'build-site.ps1' -and $t -match '(?i)LICENSE_PLACEHOLDER|CONTACT_PLACEHOLDER|to be decided') { Fail $f.Name 'placeholder text left' }
}

if ($errors.Count -gt 0) { $errors | ForEach-Object { Write-Output "FAIL $_" }; exit 1 }
Write-Output ("OK: {0} pages, languages: {1}" -f $pages.Count, ($codes -join ', '))
