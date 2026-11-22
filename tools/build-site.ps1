# Generates the static site (GitHub Pages, branch root) from site/ sources.
#   site/config.json          contact placeholder, repo, minimum Android
#   site/i18n/<code>.json     all UI texts of the home page + the policy file path of one language
#   site/policy/<code>.md     the privacy policy of that language (Markdown subset, see Convert-Markdown)
#   TERMS.md, TERMS.<code>.md the terms of use of the app builds (same Markdown subset; path in i18n termsFile)
#   site/templates/*.html     page templates
#   releases.json             published builds (written by tools/update-releases.ps1)
# Output: index.html, <code>/index.html, guide/index.html, guide/<code>/index.html (from site/guide/<code>.md), privacy/index.html, privacy/<code>/index.html, terms/index.html, terms/<code>/index.html, assets/style.css
# Works in Windows PowerShell 5.1 and PowerShell 7. No dependencies. Keep this file ASCII only.
param()
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Read-Text($path) { return [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8) }
function Write-Text($relPath, $text) {
    $full = Join-Path $Root $relPath
    $dir = Split-Path -Parent $full
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    [IO.File]::WriteAllText($full, ($text -replace "`r`n", "`n"), $Utf8)
}
function Esc($s) { return [System.Net.WebUtility]::HtmlEncode([string]$s) }

# ---- Markdown subset: # ## ### headings, paragraphs, "- " lists, pipe tables, **bold**, [text](url), bare http(s) URLs.
function Convert-Inline($text, $contactReplaced) {
    $s = Esc $text
    $s = [regex]::Replace($s, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $tokens = New-Object System.Collections.ArrayList
    $s = [regex]::Replace($s, '\[([^\]]+)\]\(([^)\s]+)\)', {
        param($m)
        $url = $m.Groups[2].Value
        # links between policy translations: privacy-policy.md, privacy-policy.<code>.md
        $pm = [regex]::Match($url, '^privacy-policy(?:\.([a-z]{2,3}))?\.md$')
        if ($pm.Success) { $code = 'en'; if ($pm.Groups[1].Success) { $code = $pm.Groups[1].Value }; $url = "../$code/" }
        $tm = [regex]::Match($url, '^TERMS(?:\.([a-z]{2,3}))?\.md$')
        if ($tm.Success) { $tcode = 'en'; if ($tm.Groups[1].Success) { $tcode = $tm.Groups[1].Value }; $url = "../$tcode/" }
        $qm = [regex]::Match($url, '^site/policy/([a-z]{2,3})\.md$')
        if ($qm.Success) { $url = '../../privacy/' + $qm.Groups[1].Value + '/' }
        $label = $m.Groups[1].Value
        if ($pm.Success -and $langs.ContainsKey($code)) { $label = Esc $langs[$code].nativeName }
        if ($tm.Success -and $langs.ContainsKey($tcode)) { $label = Esc $langs[$tcode].nativeName }
        [void]$tokens.Add('<a href="' + $url + '">' + $label + '</a>')
        return [string][char]1 + ($tokens.Count - 1) + [string][char]2
    })
    $s = [regex]::Replace($s, 'https?://[^\s<>\u0001\u0002]+', {
        param($m)
        $u = $m.Value
        $trail = ''
        while ($u -match '[)\].,;:]$') { $trail = $u.Substring($u.Length - 1) + $trail; $u = $u.Substring(0, $u.Length - 1) }
        return '<a href="' + $u + '">' + $u + '</a>' + $trail
    })
    $s = [regex]::Replace($s, "\u0001(\d+)\u0002", { param($m) $tokens[[int]$m.Groups[1].Value] })
    return $s
}

function Convert-Markdown($md, $tableLabel, $tocLabel = '') {
    $lines = ($md -replace "`r`n", "`n").Split("`n")
    $out = New-Object System.Text.StringBuilder
    $title = ''
    $tocItems = New-Object System.Collections.ArrayList
    $listTag = 'ul'
    $para = New-Object System.Collections.ArrayList
    $list = New-Object System.Collections.ArrayList
    $table = New-Object System.Collections.ArrayList
    $flushPara = {
        if ($para.Count -gt 0) { [void]$out.AppendLine('<p>' + (Convert-Inline ($para -join ' ')) + '</p>'); $para.Clear() }
    }
    $flushList = {
        if ($list.Count -gt 0) {
            [void]$out.AppendLine('<' + $listTag + '>')
            foreach ($i in $list) { [void]$out.AppendLine('<li>' + (Convert-Inline $i) + '</li>') }
            [void]$out.AppendLine('</' + $listTag + '>'); $list.Clear()
        }
    }
    $flushTable = {
        if ($table.Count -gt 0) {
            [void]$out.AppendLine('<div class="tablewrap" role="region" tabindex="0" aria-label="' + (Esc $tableLabel) + '">')
            [void]$out.AppendLine('<table>')
            $row = 0
            foreach ($r in $table) {
                $cells = $r.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }
                if ($row -eq 1 -and ($cells -join '') -match '^[-: ]+$') { $row++; continue }
                if ($row -eq 0) { [void]$out.AppendLine('<thead><tr>' + (($cells | ForEach-Object { '<th scope="col">' + (Convert-Inline $_) + '</th>' }) -join '') + '</tr></thead><tbody>') }
                else { [void]$out.AppendLine('<tr>' + (($cells | ForEach-Object { '<td>' + (Convert-Inline $_) + '</td>' }) -join '') + '</tr>') }
                $row++
            }
            [void]$out.AppendLine('</tbody></table></div>'); $table.Clear()
        }
    }
    foreach ($line in $lines) {
        if ($line -match '^\|') { & $flushPara; & $flushList; [void]$table.Add($line); continue }
        & $flushTable
        if ($line -match '^\[\[toc\]\]\s*$') { & $flushPara; & $flushList; [void]$out.AppendLine('<!--TOC-->') }
        elseif ($line -match '^(#{1,3})\s+(.+?)(?:\s+\{#([a-z0-9-]+)\})?\s*$') {
            & $flushPara; & $flushList
            $lvl = $Matches[1].Length; $txt = $Matches[2].Trim(); $hid = $Matches[3]
            if ($lvl -eq 1 -and -not $title) { $title = $txt }
            $idAttr = ''
            if ($hid) { $idAttr = ' id="' + $hid + '"'; if ($lvl -eq 2) { [void]$tocItems.Add(@{ Id = $hid; Text = $txt }) } }
            [void]$out.AppendLine("<h$lvl$idAttr>" + (Convert-Inline $txt) + "</h$lvl>")
        }
        elseif ($line -match '^>\s+(.+)$') { & $flushPara; & $flushList; [void]$out.AppendLine('<div class="alpha"><p>' + (Convert-Inline $Matches[1].Trim()) + '</p></div>') }
        elseif ($line -match '^-\s+(.+)$') { & $flushPara; if ($listTag -ne 'ul') { & $flushList }; $listTag = 'ul'; [void]$list.Add($Matches[1].Trim()) }
        elseif ($line -match '^\d+\.\s+(.+)$') { & $flushPara; if ($listTag -ne 'ol') { & $flushList }; $listTag = 'ol'; [void]$list.Add($Matches[1].Trim()) }
        elseif ($line.Trim() -eq '') { & $flushPara; & $flushList }
        else { & $flushList; [void]$para.Add($line.Trim()) }
    }
    & $flushPara; & $flushList; & $flushTable
    $html = $out.ToString()
    if ($tocItems.Count -gt 0 -and $tocLabel) {
        $toc = '<nav class="toc" aria-labelledby="toc-h"><h2 id="toc-h">' + (Esc $tocLabel) + '</h2><ol>' +
            (($tocItems | ForEach-Object { '<li><a href="#' + $_.Id + '">' + (Convert-Inline $_.Text) + '</a></li>' }) -join '') + '</ol></nav>'
        $html = $html.Replace('<!--TOC-->', $toc)
    }
    return @{ Html = $html; Title = $title }
}

# ---- Templates
function Fill($template, $vars) {
    return [regex]::Replace($template, '\{\{(\w+)\}\}', {
        param($m)
        $k = $m.Groups[1].Value
        if (-not $vars.ContainsKey($k)) { throw "Template key not provided: $k" }
        return [string]$vars[$k]
    })
}
function Li-List($items) { return (($items | ForEach-Object { '<li>' + (Esc $_) + '</li>' }) -join "`n") }

# ---- Load data
$config = (Read-Text (Join-Path $Root 'site/config.json')) | ConvertFrom-Json
$langs = @{}
foreach ($f in Get-ChildItem (Join-Path $Root 'site/i18n') -Filter '*.json') {
    $j = (Read-Text $f.FullName) | ConvertFrom-Json
    if ($j.code -ne $f.BaseName) { throw "$($f.Name): code '$($j.code)' differs from the file name" }
    $langs[$j.code] = $j
}
if (-not $langs.ContainsKey('en')) { throw 'site/i18n/en.json is required (English is the fallback)' }
$codes = @('en') + @($langs.Keys | Where-Object { $_ -ne 'en' } | Sort-Object)
$releasesPath = Join-Path $Root 'releases.json'
$releases = @()
if (Test-Path $releasesPath) { $rj = (Read-Text $releasesPath) | ConvertFrom-Json; if ($rj.releases) { $releases = @($rj.releases) } }
$tplLayout = Read-Text (Join-Path $Root 'site/templates/layout.html')
$tplHome = Read-Text (Join-Path $Root 'site/templates/home.html')
$tplPolicy = Read-Text (Join-Path $Root 'site/templates/policy.html')
$tplChooser = Read-Text (Join-Path $Root 'site/templates/chooser.html')
$repo = [string]$config.repo
$contact = Esc $config.contact

function Foot-Vars($code, $prefix) {
    $t = $langs[$code].t
    return @{ termsUrl = ($prefix + 'terms/' + $code + '/'); termsLink = (Esc $t.termsLink); licenseUrl = ('https://github.com/' + $repo + '/blob/main/LICENSE'); licenseLink = (Esc $t.licenseLink)
        guideUrl = ($prefix + 'guide/' + $code + '/'); guideLink = (Esc $t.guideLink) }
}
function Merge-Vars($a, $b) { foreach ($k in $b.Keys) { $a[$k] = $b[$k] }; return $a }
function Accept-Html($t, $termsUrl) { return (Esc $t.downloadAccept).Replace('%TERMS%', '<a href="' + $termsUrl + '">' + (Esc $t.termsLink) + '</a>') }

function Fmt-Size($bytes) { return [string]::Format([Globalization.CultureInfo]::InvariantCulture, '{0:0.0} MB', ([double]$bytes / 1MB)) }
function Dl-Url($r) { return "https://github.com/$repo/releases/download/$($r.tag)/$($r.file)" }
function Rel-Url($r) { return "https://github.com/$repo/releases/tag/$($r.tag)" }

function Latest-Html($r, $none, $t, $termsUrl) {
    if (-not $r) { return '<p>' + (Esc $none) + '</p>' }
    $label = $t.downloadLink.Replace('%FILE%', $r.file).Replace('%SIZE%', (Fmt-Size $r.size))
    return ('<p><strong>' + (Esc $r.version) + '</strong>, ' + (Esc $r.date) + '</p>' + "`n" +
        '<p><a class="button" href="' + (Esc (Dl-Url $r)) + '">' + (Esc $label) + '</a></p>' + "`n" +
        '<p><a href="' + (Esc (Rel-Url $r)) + '">' + (Esc $t.releasePage) + '</a> | <a href="' + $termsUrl + '">' + (Esc $t.termsLink) + '</a></p>')
}
function Table-Html($list, $t, $tableLabel, $termsUrl) {
    if ($list.Count -eq 0) { return '<p>' + (Esc $t.buildsNone) + '</p>' }
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('<div class="tablewrap" role="region" tabindex="0" aria-label="' + (Esc $tableLabel) + '"><table><thead><tr>')
    foreach ($k in 'colVersion', 'colDate', 'colChannel', 'colSize', 'colSha', 'colNotes', 'colFile') { [void]$sb.Append('<th scope="col">' + (Esc $t.$k) + '</th>') }
    [void]$sb.AppendLine('</tr></thead><tbody>')
    foreach ($r in $list) {
        $ch = $t.chAlpha; if ($r.channel -eq 'stable') { $ch = $t.chStable }
        [void]$sb.AppendLine('<tr><td>' + (Esc $r.version) + '</td><td>' + (Esc $r.date) + '</td><td>' + (Esc $ch) + '</td><td>' + (Fmt-Size $r.size) +
            '</td><td><span class="sha">' + (Esc $r.sha256) + '</span></td><td>' + (Esc $r.notes) + '</td><td><a href="' + (Esc (Dl-Url $r)) + '">' + (Esc $r.file) + '</a> (<a href="' + $termsUrl + '">' + (Esc $t.termsLink) + '</a>)</td></tr>')
    }
    [void]$sb.AppendLine('</tbody></table></div>')
    return $sb.ToString()
}

function Lang-Links($current, $hrefPrefix) {
    $items = foreach ($c in $codes) {
        $cur = ''; if ($c -eq $current) { $cur = ' aria-current="page"' }
        '<li><a href="' + $hrefPrefix + $c + '/" lang="' + $c + '" hreflang="' + $c + '"' + $cur + '>' + (Esc $langs[$c].nativeName) + '</a></li>'
    }
    return ($items -join "`n")
}
function Alternates($hrefPrefix) {
    $items = foreach ($c in $codes) { '<link rel="alternate" hreflang="' + $c + '" href="' + $hrefPrefix + $c + '/">' }
    return ($items -join "`n")
}

# ---- Generate
$written = New-Object System.Collections.ArrayList
$alpha = @($releases | Where-Object { $_.channel -eq 'alpha' }) | Select-Object -First 1
$stable = @($releases | Where-Object { $_.channel -eq 'stable' }) | Select-Object -First 1

function Build-Home($code, $outPath, $prefix, $homeUrl) {
    $L = $langs[$code]; $t = $L.t
    $jsKeys = 'downloadLink', 'releasePage', 'noAlpha', 'noStable', 'buildsNone', 'colVersion', 'colDate', 'colChannel', 'colSize', 'colSha', 'colNotes', 'colFile', 'chAlpha', 'chStable'
    $termsUrl = $prefix + 'terms/' + $code + '/'
    $js = [ordered]@{ tableLabel = $L.tableLabel; termsUrl = $termsUrl; termsLink = $t.termsLink }
    foreach ($k in $jsKeys) { $js[$k] = $t.$k }
    $main = Fill $tplHome (Merge-Vars (Foot-Vars $code $prefix) @{ downloadAcceptHtml = (Accept-Html $t $termsUrl)
        appName = (Esc $config.appName); whatText = (Esc $t.whatText); alphaHeading = (Esc $t.alphaHeading); alphaText = (Esc $t.alphaText); alphaText2 = (Esc $t.alphaText2)
        canHeading = (Esc $t.canHeading); canIntro = (Esc $t.canIntro); can = (Li-List $t.can)
        whatHeading = (Esc $t.whatHeading); whatText2 = (Esc $t.whatText2); whoHeading = (Esc $t.whoHeading); whoText = (Esc $t.whoText); who = (Li-List $t.who)
        howHeading = (Esc $t.howHeading); how = (Li-List $t.how); howText = (Esc $t.howText)
        downloadHeading = (Esc $t.downloadHeading); downloadIntro = (Esc $t.downloadIntro.Replace('%ANDROID%', $config.androidMin))
        latestAlpha = (Esc $t.latestAlpha); latestStable = (Esc $t.latestStable)
        latestAlphaHtml = (Latest-Html $alpha $t.noAlpha $t $termsUrl); latestStableHtml = (Latest-Html $stable $t.noStable $t $termsUrl)
        buildsHeading = (Esc $t.buildsHeading); buildsTable = (Table-Html $releases $t $L.tableLabel $termsUrl); buildsNote = (Esc $t.buildsNote)
        installHeading = (Esc $t.installHeading); install = (Li-List $t.install); installText = (Esc $t.installText)
        useHeading = (Esc $t.useHeading); useText = (Esc $t.useText); use = (Li-List $t.use); useGuideText = (Esc $t.useGuideText)
        privacyHeading = (Esc $t.privacyHeading); privacyText = (Esc $t.privacyText); privacyUrl = ($prefix + 'privacy/' + $code + '/'); privacyLink = (Esc $t.privacyLink)
        contactHeading = (Esc $t.contactHeading); contactText = (Esc $t.contactText); issuesUrl = "https://github.com/$repo/issues"; issuesLink = (Esc $t.issuesLink)
        contactLabel = (Esc $t.contactLabel); contact = $contact; licenseNote = (Esc $t.licenseNote)
        repo = (Esc $repo); lang = $code; prefix = $prefix; jsData = ($js | ConvertTo-Json -Compress)
    })
    $page = Fill $tplLayout (Merge-Vars (Foot-Vars $code $prefix) @{
        lang = $code; dir = $L.dir; title = (Esc $t.title); description = (Esc $t.description); prefix = $prefix; alternates = (Alternates $prefix)
        skip = (Esc $t.skip); homeUrl = $homeUrl; appName = (Esc $config.appName); langNav = (Esc $t.langNav)
        langLinks = (Lang-Links $code $prefix); main = $main; footer = (Esc $t.footer)
    })
    Write-Text $outPath $page; [void]$written.Add($outPath)
}

foreach ($c in $codes) { Build-Home $c "$c/index.html" '../' './' }
# Root page: the English home page (the fallback), links are relative to the root.
Build-Home 'en' 'index.html' '' './'

foreach ($c in $codes) {
    $L = $langs[$c]; $t = $L.t
    $policyPath = Join-Path $Root $L.policyFile
    if (-not (Test-Path $policyPath)) { throw "Policy file missing for ${c}: $($L.policyFile)" }
    $md = Read-Text $policyPath
    if ($config.contact -ne 'CONTACT_PLACEHOLDER' -and $L.policyContactPlaceholder) { $md = $md.Replace($L.policyContactPlaceholder, [string]$config.contact) }
    $conv = Convert-Markdown $md $L.tableLabel
    $notice = ''
    if ($L.policyNotice) { $notice = '<p class="notice">' + (Esc $L.policyNotice) + ' <a href="../en/" lang="en" hreflang="en">English</a></p>' }
    $main = Fill $tplPolicy @{ notice = $notice; policyHtml = $conv.Html; homeUrl = "../../$c/"; policyBack = (Esc $L.policyBack) }
    $page = Fill $tplLayout (Merge-Vars (Foot-Vars $c '../../') @{
        lang = $c; dir = $L.dir; title = (Esc $conv.Title); description = (Esc $conv.Title); prefix = '../../'; alternates = (Alternates '../')
        skip = (Esc $t.skip); homeUrl = "../../$c/"; appName = (Esc $config.appName); langNav = (Esc $t.langNav)
        langLinks = (Lang-Links $c '../'); main = $main; footer = (Esc $t.footer)
    })
    Write-Text "privacy/$c/index.html" $page; [void]$written.Add("privacy/$c/index.html")
}

# Terms pages: the same pattern as the policy pages (source: TERMS.md / TERMS.<code>.md in the repository root).
foreach ($c in $codes) {
    $L = $langs[$c]; $t = $L.t
    $termsPath = Join-Path $Root $L.termsFile
    if (-not (Test-Path $termsPath)) { throw "Terms file missing for ${c}: $($L.termsFile)" }
    $conv = Convert-Markdown (Read-Text $termsPath) $L.tableLabel
    $notice = ''
    if ($L.termsNotice) { $notice = '<p class="notice">' + (Esc $L.termsNotice) + ' <a href="../en/" lang="en" hreflang="en">English</a></p>' }
    $main = Fill $tplPolicy @{ notice = $notice; policyHtml = $conv.Html; homeUrl = "../../$c/"; policyBack = (Esc $L.policyBack) }
    $page = Fill $tplLayout (Merge-Vars (Foot-Vars $c '../../') @{
        lang = $c; dir = $L.dir; title = (Esc $conv.Title); description = (Esc $conv.Title); prefix = '../../'; alternates = (Alternates '../')
        skip = (Esc $t.skip); homeUrl = "../../$c/"; appName = (Esc $config.appName); langNav = (Esc $t.langNav)
        langLinks = (Lang-Links $c '../'); main = $main; footer = (Esc $t.footer)
    })
    Write-Text "terms/$c/index.html" $page; [void]$written.Add("terms/$c/index.html")
}

# Guide pages (source: site/guide/<code>.md): the policy pattern, plus a table of contents built from the h2 headings that carry {#id}.
# Placeholders in the guide text: [[contact]], [[androidmin]], [[repo]].
foreach ($c in $codes) {
    $L = $langs[$c]; $t = $L.t
    $guidePath = Join-Path $Root ('site/guide/' + $c + '.md')
    if (-not (Test-Path $guidePath)) { throw "Guide file missing for ${c}: site/guide/$c.md" }
    $gmd = (Read-Text $guidePath).Replace('[[contact]]', [string]$config.contact).Replace('[[androidmin]]', [string]$config.androidMin).Replace('[[repo]]', $repo)
    $conv = Convert-Markdown $gmd $L.tableLabel $t.guideToc
    $main = Fill $tplPolicy @{ notice = ''; policyHtml = $conv.Html; homeUrl = "../../$c/"; policyBack = (Esc $L.policyBack) }
    $page = Fill $tplLayout (Merge-Vars (Foot-Vars $c '../../') @{
        lang = $c; dir = $L.dir; title = (Esc $conv.Title); description = (Esc $t.guideDescription); prefix = '../../'; alternates = (Alternates '../')
        skip = (Esc $t.skip); homeUrl = "../../$c/"; appName = (Esc $config.appName); langNav = (Esc $t.langNav)
        langLinks = (Lang-Links $c '../'); main = $main; footer = (Esc $t.footer)
    })
    Write-Text "guide/$c/index.html" $page; [void]$written.Add("guide/$c/index.html")
}

# Language choosers for /privacy/, /terms/ and /guide/: JavaScript picks a language, <noscript> lists all of them.
$en = $langs['en']
foreach ($sec in @(@{ dir = 'privacy'; key = 'privacyLink' }, @{ dir = 'terms'; key = 'termsLink' }, @{ dir = 'guide'; key = 'guideLink' })) {
    $key = $sec.key
    $heading = ($codes | ForEach-Object { $langs[$_].t.$key }) -join ' / '
    $choose = ($codes | ForEach-Object { $langs[$_].t.chooseLang }) -join ' / '
    $links = ($codes | ForEach-Object { '<li><a href="' + $_ + '/" lang="' + $_ + '" hreflang="' + $_ + '">' + (Esc $langs[$_].nativeName) + ': ' + (Esc $langs[$_].t.$key) + '</a></li>' }) -join "`n"
    $avail = '[' + (($codes | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'
    $main = Fill $tplChooser @{ heading = (Esc $heading); appName = (Esc $config.appName); noscriptText = (Esc $choose); chooserLinks = $links; availJson = $avail }
    $page = Fill $tplLayout (Merge-Vars (Foot-Vars 'en' '../') @{
        lang = 'en'; dir = 'ltr'; title = (Esc ($en.t.$key + ' | ' + $config.appName)); description = (Esc $en.t.$key); prefix = '../'; alternates = (Alternates '')
        skip = (Esc $en.t.skip); homeUrl = '../en/'; appName = (Esc $config.appName); langNav = (Esc $en.t.langNav)
        langLinks = (Lang-Links '' ''); main = $main; footer = (Esc $en.t.footer)
    })
    Write-Text ($sec.dir + '/index.html') $page; [void]$written.Add($sec.dir + '/index.html')
}
# Static assets
$assetDir = Join-Path $Root 'assets'
if (-not (Test-Path $assetDir)) { New-Item -ItemType Directory -Path $assetDir | Out-Null }
Copy-Item (Join-Path $Root 'site/assets/style.css') (Join-Path $assetDir 'style.css') -Force
[void]$written.Add('assets/style.css')

Write-Output ("Generated {0} files for languages: {1}" -f $written.Count, ($codes -join ', '))
$written | ForEach-Object { Write-Output "  $_" }
