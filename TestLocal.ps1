


. ./DockerHelper.ps1

Build-DockerImage -Dockerfile ".\fibonacci-app\Dockerfile" -Tag "fb_image" -Context ".\fibonacci-app"

Run-DockerContainer -ImageName "fb_image" -ContainerParams 10 

Run-DockerContainer -ImageName "fb_image" -ContainerParams ""