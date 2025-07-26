$ErrorActionPreference = "Stop"

write-host
Write-Host "The current command (irm https://massgrave.dev/get | iex) will be retired on Aug 31, 2024."
Write-Host -ForegroundColor Green "Use the new command (irm https://get.activated.win | iex) moving forward."
write-host

# Enable TLSv1.2 for compatibility with older clients for current session
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

$DownloadURL1 = 'https://raw.githubusercontent.com/ictcentervnn/Active-windows-and-IDM/refs/heads/main/MAS_AIO_3.4.cmd'
$DownloadURL2 = 'https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&versionType=Commit&version=67abcd0c8925832fcf4365b9cf3706ab6fbf8571'

$URLs = @($DownloadURL1, $DownloadURL2)
$RandomURL1 = Get-Random -InputObject $URLs
$RandomURL2 = $URLs -ne $RandomURL1

try {
    $response = Invoke-WebRequest -Uri $RandomURL1 -UseBasicParsing
}
catch {
	$response = Invoke-WebRequest -Uri $RandomURL2 -UseBasicParsing
}

$rand = Get-Random -Maximum 99999999
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }

$ScriptArgs = "$args "
$prefix = "@::: $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
