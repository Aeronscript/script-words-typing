# build.ps1 - compile src/ en un seul fichier autotyper_build.lua
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $base "src"
$out = Join-Path $base "autotyper_build.lua"

$files = @("dictionary.lua", "core.lua", "gui.lua")

$content = ""
$content += "-- FTW Ultra Pro - build auto ($(Get-Date -Format 'yyyy-MM-dd'))`n"
$content += "-- Genere par build.ps1`n`n"

foreach ($f in $files) {
    $p = Join-Path $src $f
    $c = Get-Content -LiteralPath $p -Raw -Encoding UTF8
    # transformer le "return { ... }" final en assignation globale pour eviter de couper le chunk
    if ($f -eq "dictionary.lua") {
        $c = $c -replace 'return \{', '_G.DICT = {'
    } elseif ($f -eq "core.lua") {
        $c = $c -replace 'return \{', '_G.CORE = {'
    }
    $content += "-- ===== " + $f + " =====`n"
    $content += $c + "`n`n"
}

# main (inline)
$content += "-- ===== main (inline) =====`n"
$content += '_G.CORE.start()' + "`n"
$content += 'print("[FTW] Ultra Pro demarre")' + "`n"

Set-Content -LiteralPath $out -Value $content -Encoding UTF8
$size = (Get-Item $out).Length
Write-Host "Build ecrit: $out ($size bytes)"
