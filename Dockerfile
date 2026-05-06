FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

RUN dotnet new web -n app
WORKDIR /src/app

RUN printf '%s\n' \
'var builder = WebApplication.CreateBuilder(args);' \
'var app = builder.Build();' \
'app.MapGet("/health", () => "OK");' \
'app.MapGet("/version", () => "0.1");' \
'app.MapGet("/db/ping", () => "DB OK");' \
'app.Run("http://0.0.0.0:5000");' \
> Program.cs

RUN dotnet publish -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .
EXPOSE 5000
ENTRYPOINT ["dotnet", "app.dll"]
