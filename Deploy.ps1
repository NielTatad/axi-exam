# Deploy.ps1
# One-click deployment script for super-service using docker-compose

Write-Host "=== Super Service Deployment Started ===" -ForegroundColor Cyan

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker is not installed or not in PATH. Please install Docker Desktop first."
    exit 1
}

$dockerComposeCmd = "docker-compose"

Write-Host "Cleaning up old containers..." -ForegroundColor Yellow
& $dockerComposeCmd down --remove-orphans

Write-Host "Building and starting containers..." -ForegroundColor Green
& $dockerComposeCmd up -d --build

Write-Host "Deployment complete. Running containers:" -ForegroundColor Cyan
docker ps --filter "name=super-service"

Write-Host "=== Super Service Deployment Finished ===" -ForegroundColor Green
