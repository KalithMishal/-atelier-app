# Deploy Firestore rules/indexes, then Storage rules (after Storage is enabled in Console).
$ErrorActionPreference = "Stop"
$ProjectId = "fashion-store-app-2ac1f"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

Write-Host "Using project: $ProjectId" -ForegroundColor Cyan
firebase use $ProjectId | Out-Null

Write-Host "`n[1/2] Deploying Firestore rules and indexes..." -ForegroundColor Yellow
firebase deploy --only firestore:rules,firestore:indexes
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n[2/2] Deploying Storage rules..." -ForegroundColor Yellow
firebase deploy --only storage:rules
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nAll Firebase rules deployed successfully." -ForegroundColor Green
    exit 0
}

Write-Host "`nStorage is not set up yet on this project." -ForegroundColor Red
Write-Host "Opening Firebase Console — click 'Get started' on the Storage page, then run this script again.`n" -ForegroundColor Yellow
Start-Process "https://console.firebase.google.com/project/$ProjectId/storage"
exit 1
