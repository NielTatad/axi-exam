FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /src

COPY src/SuperService.csproj src/

RUN dotnet restore src/SuperService.csproj

COPY src/ src/

RUN dotnet publish src/SuperService.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Development

COPY --from=build /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "SuperService.dll"]
