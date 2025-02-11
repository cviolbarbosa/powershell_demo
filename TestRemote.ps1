
$Cred = New-Object System.Management.Automation.PSCredential($Username, $SecureStringPassword)

Import-Module -Name "./DockerHelper.ps1"

Copy-Prerequisites -ComputerName "DESKTOP-PVKD3T9" -Path ".\fibonacci-app" -Destination "D"

Build-DockerImage -ComputerName "DESKTOP-PVKD3T9" -Dockerfile "D:\fibonacci-app\Dockerfile" -Tag "fb_image" -Context "D:\fibonacci-app"

$containerName = Run-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ImageName "fb_image" -DockerParams "--detach" -ContainerParams ""

Log-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ContainerName $containerName
Start-Sleep -Seconds 3
Log-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ContainerName $containerName
Start-Sleep -Seconds 3
Log-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ContainerName $containerName
