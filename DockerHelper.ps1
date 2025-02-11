function Build-DockerImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Dockerfile,  # Path to the Dockerfile
        [Parameter(Mandatory = $true)]
        [string]$Tag,  # Docker image name
        [Parameter(Mandatory = $true)]
        [string]$Context,  # Path to Docker build context
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $null  # Remote host name (optional)
    )   

    Write-Host "Build-DockerImage function started " -ForegroundColor Green
    $command = "docker build -f `"$Dockerfile`" -t `"$Tag`" `"$Context`""

    try {
        if ($null -eq $ComputerName -or $ComputerName -eq '') {

            # Test Inputs
            if (!(Test-Path $Dockerfile)) {
                Write-Error "Dockerfile not found at: $Dockerfile"
                return
            }

            if (!(Test-Path $Context)) {
                Write-Error "Context directory not found at: $Context"
                return
            }

            # Build locally
            Write-Host "Building Docker image locally with tag '$Tag'..." -ForegroundColor Green
            Write-Host "Executing: $command" -ForegroundColor Yellow
            Invoke-Expression $command

        } else {
            # Build on a remote host
            Write-Host "Building Docker image on remote host '$ComputerName' with tag '$Tag'..." -ForegroundColor Green
            $command = "docker build -f `"$Dockerfile`" -t `"$Tag`" `"$Context`""
            Write-Host "Executing remotely: $command" -ForegroundColor Yellow
            
            Invoke-Command -ComputerName $ComputerName  -Credential $Cred   -ScriptBlock {
                param($cmd)
                Write-Host "Running command on remote machine..." -ForegroundColor Cyan
                Invoke-Expression $cmd
            } -ArgumentList $command
        }

        Write-Host "Docker image build completed!" -ForegroundColor Cyan
    } catch {
        Write-Error "An error occurred: $_"
         Write-Host "Error during Docker build: $($_.Exception.Message)" -ForegroundColor Red

    }
}



function Run-DockerContainer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ImageName,  # Mandatory: Docker image name
        
        [Parameter(Mandatory = $false)]
        [string]$ComputerName,  # Optional: Remote host name

        [Parameter(Mandatory = $false)]
        [string[]]$DockerParams,  # Optional: Additional Function parameters
        
        [Parameter(Mandatory = $false)]
        [string[]]$ContainerParams  # Optional: Additional Docker parameters
    )

    # Build the Docker command
    $params = ""
    if ($DockerParams) {
        $params = $DockerParams -join " "
    }

    $containerName = "container_$((Get-Random).ToString('X8'))"  # Generate a random container name
    
    try {
        if ($null -eq $ComputerName -or $ComputerName -eq '') {
            # Execute locally
            $command = "docker run --rm $params --name $containerName  $ImageName  $ContainerParams"
            Write-Host "Running Docker container locally with name '$containerName'..." -ForegroundColor Green
            Write-Host "Executing: $command" -ForegroundColor Yellow
            Invoke-Expression $command
        } else {
            # Execute remotely
            $remotecommand = "docker run  --rm $params --name $containerName  $ImageName $ContainerParams"
            Write-Host "Running Docker container on remote host '$ComputerName' with name '$containerName'..." -ForegroundColor Green
            Write-Host "Executing on remote host: $command" -ForegroundColor Yellow

            $result = Invoke-Command -ComputerName $ComputerName -Credential $Cred -ScriptBlock {
                param($cmd)
                Write-Host "Running command on remote machine..." -ForegroundColor Cyan
                Invoke-Expression $cmd
            } -ArgumentList $remotecommand


        }

        return $containerName
    } catch {
        Write-Error "An error occurred while running the Docker container: $_"
        return $null
    }
}



function Copy-Prerequisites {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,  # Mandatory: The remote computer name
        
        [Parameter(Mandatory = $true)]
        [string[]]$Path,  # Mandatory: Local paths to copy from
        
        [Parameter(Mandatory = $true)]
        [string]$Destination  # Mandatory: Destination directory on the remote machine
    )


    try {
        # Loop through each local path and copy files to the remote destination
        foreach ($localPath in $Path) {
            if (Test-Path $localPath) {
                $remotePath = "\\$ComputerName\$Destination"
                Write-Host "Copying files from '$localPath' to '$remotePath'..." -ForegroundColor Green
                Copy-Item -Path $localPath -Destination $remotePath -Recurse -Force -ErrorAction Stop  
                Write-Host "Files copied successfully." -ForegroundColor Green
            } else {
                Write-Host "Local path '$localPath' does not exist. Skipping..." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Error "An error occurred while copying files: $_"
    }
}



function Log-DockerContainer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName,  # Optional: Remote host name

        [Parameter(Mandatory = $true)]
        [string]$ContainerName  # Mandatory: Docker image name
    )

    $command = "docker logs $ContainerName"

    try {
        if ($null -eq $ComputerName -or $ComputerName -eq '') {
            # Execute locally
            Write-Host "Executing: $command" -ForegroundColor Yellow
            Invoke-Expression $command
        } else {
            # Output  container logs
            Write-Host "Fetching  logs for container '$containerName' from remote host '$ComputerName'..." -ForegroundColor Green
            Invoke-Command -ComputerName $ComputerName -Credential $Cred -ScriptBlock {
                param($cmd)
                Invoke-Expression $cmd 
            } -ArgumentList  $command
        }
    } catch {
        Write-Error "An error occurred while logging the Docker container: $_"
    }
}
