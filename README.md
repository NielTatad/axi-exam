# axi-exam

# DevOps Interview Task

Thank you for taking the time to do our technical test. We need to deploy a new .NET Core Web API application using a docker container.

Write code to do the following:

1. Run the automated tests
2. Package the application as a docker image
3. Deploy and run the image locally or in a public cloud

Improvements can also be made. For example:

- Make any changes to the application you think are useful for a deploy process
- Host the application in a secure fashion

The application is included under [`.\super-service`](`.\super-service`).

Your solution should be triggered by a powershell script called `Deploy.ps1`.

## Submitting

Create a Git repository which includes instructions on how to run the solution.  

## Prerequisites
- Docker Desktop
- Windows PowerShell (to run `Deploy.ps1`).

## Solution (what was done)
- **Dockerfile** kept as a multi-stage build targeting a .NET Core 3.1 app:
  - Builds and publishes the app in a lightweight runtime image
  - App listens on container port 80 (default for ASP.NET Core in Docker)
- **Docker Compose** configured to:
  - Build from repo root (`context: .`) using `Dockerfile`
  - Run the container as `super-service:local`
  - Map host port `8081` to container port `80` (avoids conflict with Jenkins on `8080`)
  - Set `ASPNETCORE_ENVIRONMENT=Development`
  - Restart container automatically on failure (`restart: always`)
- **Deploy.ps1** (one-click deployment script):
  - Verifies Docker is installed
  - Stops and removes any existing containers (`docker-compose down --remove-orphans`)
  - Rebuilds and starts the container in detached mode (`docker-compose up -d --build`)
  - Prints running container status and access URL (`http://localhost:8081`)

### Why Docker Compose?
- **Simplicity** → Provides a single YAML file that defines how the application is built, run, and networked, avoiding manual `docker run` commands.
- **Reproducibility** → Anyone can run the same setup with one command ensuring consistent local environments.
- **Scalability** → Makes it easy to add more services later (databases, caching layers, reverse proxies, etc.) without changing the deployment workflow.
- **One-click deploy** → Integrates seamlessly with `Deploy.ps1` so the whole stack can be started, stopped or rebuilt with a single command.

Compose snippet now used:
```yaml
services:
  super-service:
    build:
      context: .
      dockerfile: Dockerfile
    image: super-service:local
    restart: always
    ports:
      - 8081:80
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
```

## Quick start (Docker Compose)
1. From the repo root:
```powershell
docker compose up -d
```
2. Open the API endpoint:
```text
http://localhost:8081/Time
```
3. Useful commands:
```powershell
docker compose logs -f super-service
docker compose ps
docker compose down
```

## Build and run with Docker Compose
Build images:
```powershell
docker compose build
```
Start in background:
```powershell
docker compose up -d
```
Tail logs:
```powershell
docker compose logs -f super-service
```
Stop:
```powershell
docker compose down
```
