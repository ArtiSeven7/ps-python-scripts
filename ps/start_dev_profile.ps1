#path to chrome
$chromePath = "$Env:ProgramFiles\Google\Chrome\Application\chrome.exe" 

if (-not (Test-Path $chromePath)) {
    $chromePath = Join-Path ${Env:ProgramFiles(x86)} "\Google\Chrome\Application\chrome.exe"
}

# Docker default path
$dockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"


$ideaPath = ""#add your idea path here""

$cheromeProfiles = Join-Path $Env:LOCALAPPDATA "Google\Chrome\User Data"

$chromeArgs = $null

if (Test-Path $cheromeProfiles) {
    $profileDirs = Get-ChildItem -Path $cheromeProfiles -Directory | 
    Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile *"} |
    Select-Object -ExpandProperty Name

} else {
    $profileDirs = @()
}

if ($profileDirs.Count -eq 0) {
    Write-Host "No Chrome profile folders were found. Chrome will launch without specifying a profile."
} else {
    Write-Host "Available Chrome profiles:`n"
    for ($i = 0; $i -lt $profileDirs.Count; $i++) {
        Write-Host ("[{0}] {1}" -f ($i + 1), $profileDirs[$i])
    }

    $selection = Read-Host "`nEnter your profile number"

    if ($selection -match '^\d+$' -and [int]$selection -ge 1 -and [int]$selection -le $profileDirs.Count) {
        $chromeProfile = $profileDirs[[int]$selection - 1]
        Write-Host "Profile selected: $chromeProfile"
        $chromeArgs = "--profile-directory=""$chromeProfile"""
    } else {
        Write-Host "Incorrect selection. The first profile will be used: $($profileDirs[0])"
        $chromeProfile = $profileDirs[0]
        $chromeArgs = "--profile-directory=""$chromeProfile"""
    }
}

if (Test-Path $chromePath) {
    if ($chromeArgs) {
        Start-Process -FilePath $chromePath -ArgumentList $chromeArgs
    } else {
        Start-Process -FilePath $chromePath
    }
} else {
    Write-Host "Chrome was not found in the path. $chromePath"
}

if (Test-Path $ideaPath) {
    Start-Process -FilePath $ideaPath
} else {
    Write-Host "IntelliJ IDEA не найдена по пути $ideaPath"
}

if (Test-Path $dockerPath) {
    Start-Process -FilePath $dockerPath
} else {
    Write-Host "Docker Desktop не найден по пути $dockerPath"
}


