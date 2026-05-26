# Re-download the Accessories department flat lay from Next Luxury (same file as in code comments).
$ErrorActionPreference = 'Stop'
$uri = 'https://nextluxury.com/wp-content/uploads/Top-15-Fashion-Accessories-For-Men-1.jpg'
$out = Join-Path $PSScriptRoot '..\assets\images\accessories_nextluxury_flatlay.jpg'
Invoke-WebRequest -Uri $uri -OutFile $out -UseBasicParsing -Headers @{ Referer = 'https://nextluxury.com/' }
Write-Host "Wrote $out ($((Get-Item $out).Length) bytes)"
