[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, HelpMessage = "Enter the path to configure the SACL on")]
    [string]$Path
)

# Prompt for path if not provided as a parameter
if (-not $Path) {
    $Path = Read-Host "Enter the target path (e.g. E:\)"
}

# Validate the path exists
if (-not (Test-Path -Path $Path)) {
    Write-Error "Path '$Path' does not exist. Exiting."
    exit 1
}

# Get existing ACL
$acl = Get-Acl $Path

# Build granular permission set
$rights = [System.Security.AccessControl.FileSystemRights]::ReadData `
        -bor [System.Security.AccessControl.FileSystemRights]::ListDirectory `
        -bor [System.Security.AccessControl.FileSystemRights]::WriteData `
        -bor [System.Security.AccessControl.FileSystemRights]::AppendData `
        -bor [System.Security.AccessControl.FileSystemRights]::ReadAttributes `
        -bor [System.Security.AccessControl.FileSystemRights]::WriteAttributes `
        -bor [System.Security.AccessControl.FileSystemRights]::ReadExtendedAttributes `
        -bor [System.Security.AccessControl.FileSystemRights]::WriteExtendedAttributes `
        -bor [System.Security.AccessControl.FileSystemRights]::Delete `
        -bor [System.Security.AccessControl.FileSystemRights]::Modify `
        -bor [System.Security.AccessControl.FileSystemRights]::FullControl

# Create audit rule for Everyone
$rule = New-Object System.Security.AccessControl.FileSystemAuditRule(
    "Everyone",
    $rights,
    [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit",
    [System.Security.AccessControl.PropagationFlags]::None,
    [System.Security.AccessControl.AuditFlags]"Success, Failure"
)

# Apply the SACL rule
$acl.AddAuditRule($rule)
Set-Acl -Path $Path -AclObject $acl

Write-Host "SACL configured successfully on $Path"
