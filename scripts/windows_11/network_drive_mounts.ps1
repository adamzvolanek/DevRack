# Start a new PowerShell session
Clear-Host

# Function to prompt for server name and validate input
function Prompt-ForServer {
    $server = Read-Host "Enter the server name (e.g., ALEXANDRIA)"
    if (-not $server) {
        Write-Host "Server name cannot be empty. Exiting..." -ForegroundColor Red
        exit
    }
    return $server
}

# Function to prompt for user and validate input
function Prompt-ForUser {
    $user = Read-Host "Are you Alex or Adam?"
    if (-not $user) {
        Write-Host "User cannot be empty. Exiting..." -ForegroundColor Red
        exit
    }
    return $user
}

# Function to prompt for credentials if secure shares are used
function Prompt-ForCredentials {
    $username = Read-Host "Enter your username"
    if (-not $username) {
        Write-Host "Username cannot be empty. Exiting..." -ForegroundColor Red
        exit
    }

    $password = Read-Host "Enter your password" -AsSecureString
    if (-not $password) {
        Write-Host "Password cannot be empty. Exiting..." -ForegroundColor Red
        exit
    }

    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    return $credential
}

# Function to check if a drive letter is already in use
function Check-DriveInUse {
    param (
        [string]$driveLetter
    )
    return (Get-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue) -ne $null
}

# Function to check if credentials exist for the server
function Check-CredentialsExist {
    param (
        [string]$server
    )
    # Check for stored credentials using cmdkey
    $storedCredentials = cmdkey /list | Select-String -Pattern $server
    return $storedCredentials -ne $null
}

# Main script logic
$server = Prompt-ForServer
$user = Prompt-ForUser

# Check if the user input is valid
if ($user -ne "Adam" -and $user -ne "Alex") {
    Write-Host "Invalid user. Please enter either 'Adam' or 'Alex'. Exiting..." -ForegroundColor Red
    exit
}

$secure = Read-Host "Are you using secure shares? (Y/N)"

if ($secure -eq "Y" -or $secure -eq "y") {
    if (Check-CredentialsExist -server $server) {
        Write-Host "Credential for $server already exists. No need to enter again."
    } else {
        $credential = Prompt-ForCredentials
        cmdkey /add:$server /user:$credential.UserName /pass:$($credential.GetNetworkCredential().Password)
    }
}

# Common mounts
$commonShares = @{"P"="\\$server\pictures"; "V"="\\$server\videos"}

foreach ($drive in $commonShares.GetEnumerator()) {
    if (-not (Check-DriveInUse -driveLetter $drive.Key)) {
        Try {
            New-PSDrive -Name $drive.Key -PSProvider FileSystem -Root $drive.Value -Persist
            Write-Host "$($drive.Value) mounted under $($drive.Key)"
        } Catch {
            Write-Host "Failed to mount $($drive.Value): $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Drive letter $($drive.Key) is already in use for path $($drive.Value). Skipping mount." -ForegroundColor Yellow
    }
}

# User-specific mounts
if ($user -eq "Adam") {
    $adamShares = @{"A"="\\$server\cloud\Adam"; "B"="\\$server\DevRack"; "Z"="\\$server\backups"}

    foreach ($drive in $adamShares.GetEnumerator()) {
        if (-not (Check-DriveInUse -driveLetter $drive.Key)) {
            Try {
                New-PSDrive -Name $drive.Key -PSProvider FileSystem -Root $drive.Value -Persist
                Write-Host "$($drive.Value) mounted under $($drive.Key)"
            } Catch {
                Write-Host "Failed to mount $($drive.Value): $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Drive letter $($drive.Key) is already in use for path $($drive.Value). Skipping mount." -ForegroundColor Yellow
        }
    }
} elseif ($user -eq "Alex") {
    if (-not (Check-DriveInUse -driveLetter "A")) {
        Try {
            New-PSDrive -Name "A" -PSProvider FileSystem -Root "\\$server\Alex" -Persist
            Write-Host "\\$server\Alex mounted under A"
        } Catch {
            Write-Host "Failed to mount \\$server\Alex: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Drive letter A is already in use for path \\$server\Alex. Skipping mount." -ForegroundColor Yellow
    }
}

# Optional delay before exiting
Start-Sleep -Seconds 5
