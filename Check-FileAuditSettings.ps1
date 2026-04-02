# Run as Administrator
# Checks for File Audit settings
# Event ID 4663 and 5145
# Checks for appropriate SACLS

param(
    [string]$TargetPath = "C:\SensitiveFolder"
)

Write-Host "`n=== AUDIT POLICY STATUS ===" -ForegroundColor Cyan
Write-Host "`n[4663] File System:" -ForegroundColor Yellow
auditpol /get /subcategory:"File System"
Write-Host "`n[5145] Detailed File Share:" -ForegroundColor Yellow
auditpol /get /subcategory:"Detailed File Share"

Write-Host "`n=== SACL CHECK: $TargetPath ===" -ForegroundColor Cyan

if (-not (Test-Path $TargetPath)) {
    Write-Host "Path not found: $TargetPath" -ForegroundColor Red
    exit
}

$acl = Get-Acl -Path $TargetPath -Audit -ErrorAction SilentlyContinue

if ($acl.Audit.Count -eq 0) {
    Write-Host "WARNING: No SACL entries found! Event ID 4663 will NOT fire." -ForegroundColor Red
} else {
    Write-Host "SACL entries found:" -ForegroundColor Green
    $acl.Audit | ForEach-Object {
        [PSCustomObject]@{
            Identity         = $_.IdentityReference
            Rights           = $_.FileSystemRights
            AuditFlags       = $_.AuditFlags
            Inherited        = $_.IsInherited
        }
    } | Format-Table -AutoSize
}

# Check for recent 4663/5145 events as confirmation
Write-Host "`n=== RECENT EVENTS (last 24hrs) ===" -ForegroundColor Cyan
$since = (Get-Date).AddDays(-1)

@(4663, 5145) | ForEach-Object {
    $id = $_
    $count = (Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = $id
        StartTime = $since
    } -ErrorAction SilentlyContinue).Count
    Write-Host "Event ID $id : $count occurrences in last 24 hours" -ForegroundColor White
}
