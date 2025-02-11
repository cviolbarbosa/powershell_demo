
# How to Use PowerShell Cmdlets to Build and Run Docker Containers Remotely

This code was tested using two Windows computers (Windows 10 and Windows 11) within the same WORKGROUP in a private network.

## Local Docker Build and Run  

This guide demonstrates how to build and run a Docker container on the local machine using a single PowerShell script.

```powershell
# Load the Docker functions
. .\DockerHelper.ps1

# Copy files, build image, and run container
Build-DockerImage -Dockerfile ".\fibonacci-app\Dockerfile" -Tag "fb_image" -Context ".\fibonacci-app"
Run-DockerContainer -ImageName "fb_image" -DockerParams 10
```


## Remote Docker Build and Run  

This guide demonstrates how to build and run a Docker container on a remote machine using a single PowerShell script.

```powershell
# Set up remote credentials
$Username = "$RemoteAccount"
$Password = "$RemotePassword" | ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($Username, $Password)

# Load the Docker Cmdlets
. .\DockerHelper.ps1

# Copy files, build image, and run container
Copy-Prerequisites -ComputerName "DESKTOP-PVKD3T9" -Path ".\fibonacci-app" -Destination "D"

Build-DockerImage -ComputerName "DESKTOP-PVKD3T9" -Dockerfile "D:\fibonacci-app\Dockerfile" -Tag "fb_image" -Context "D:\fibonacci-app"

$containerName = Run-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ImageName "fb_image" -DockerParams "--detach" -ContainerParams ""

Log-DockerContainer -ComputerName "DESKTOP-PVKD3T9" -ContainerName $containerName

```

## Preparation  

This section describes the setup for the two machines: Windows 11 as the server and Windows 10 as the client.

### On the Windows 11 (Server) Machine  
Enable PowerShell remoting by running:  

```powershell
Enable-PSRemoting -Force
```

### On the Windows 10 (Client) Machine  
Allow the client to trust the server by adding the server's hostname to the trusted hosts list:

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "ServerName" -Concatenate
```

### Test the Configuration  
```powershell
Invoke-Command -ComputerName ServerName -ScriptBlock { hostname }

```
If configured correctly, the server's hostname will be displayed in the output.



