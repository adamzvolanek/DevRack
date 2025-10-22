<#
.SYNOPSIS
  Prompts for target, username, and password, adds a credential to Windows Credential Manager,
  then opens the Control Panel UI to view Windows Credentials after a short delay.
#>

$ErrorActionPreference = 'Stop'

function Convert-SecureStringToPlainText {
    param([System.Security.SecureString]$SecureString)
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    try { [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

Write-Host "Add a credential to Windows Credential Manager" -ForegroundColor Cyan

$target   = Read-Host "Enter the location / address (e.g. server.domain.com, https://example.com, or \\fileserver\share)"
$username = Read-Host "Enter the username (e.g. DOMAIN\User or user@example.com)"
$securePwd = Read-Host "Enter the password" -AsSecureString

Write-Host ""
Write-Host "About to create credential for:" -ForegroundColor Yellow
Write-Host "  Target  : $target"
Write-Host "  Username: $username"

$confirm = Read-Host "Proceed and save this credential? (Y/N)"
if ($confirm -notin @('Y','y','Yes','yes')) {
    Write-Host "Aborted by user." -ForegroundColor Red
    exit 1
}

# Convert password
$plainPwd = Convert-SecureStringToPlainText -SecureString $securePwd

try {
    $args = "/add:$($target)", "/user:$($username)", "/pass:$plainPwd"
    $proc = Start-Process cmdkey.exe -ArgumentList $args -NoNewWindow -Wait -PassThru

    if ($proc.ExitCode -eq 0) {
        Write-Host "`nCredential added successfully." -ForegroundColor Green

        # 2-second countdown
        for ($i = 2; $i -ge 1; $i--) {
            Write-Host ("Opening Credential Manager in {0} second{1}..." -f $i, ($(if ($i -gt 1) {'s'} else {''})))
            Start-Sleep -Seconds 1
        }

        Write-Host "`nOpening Windows Credential Manager..." -ForegroundColor Cyan
        Start-Process "control.exe" "keymgr.dll"
    } else {
        Write-Host "`ncmdkey returned exit code $($proc.ExitCode)." -ForegroundColor Red
        exit 1
    }
}
finally {
    $plainPwd = $null
    $securePwd = $null
}
