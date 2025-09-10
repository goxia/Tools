@echo off
setlocal enableextensions
echo Building WinPlusH-dotNet for multiple deployment options...

echo.
echo Ensuring nuget.org source is configured...
dotnet nuget list source | findstr /I "nuget.org" >nul
if errorlevel 1 (
	echo Adding nuget.org source...
	dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
)

echo.
echo Building AnyCPU portable (framework-dependent)...
dotnet publish -c Release
if errorlevel 1 goto :fail

echo.
echo Building Windows x64 single-file (framework-dependent)...
dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true -o bin\Release\net6.0\win-x64\publish-fdd
if errorlevel 1 goto :fail

echo.
echo Building Windows ARM64 single-file (framework-dependent)...
dotnet publish -c Release -r win-arm64 --self-contained false /p:PublishSingleFile=true -o bin\Release\net6.0\win-arm64\publish-fdd
if errorlevel 1 goto :fail

echo.
echo Building Windows x64 single-file (self-contained)...
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true -o bin\Release\net6.0\win-x64\publish-scd
if errorlevel 1 goto :fail

echo.
echo Building Windows ARM64 single-file (self-contained)...
dotnet publish -c Release -r win-arm64 --self-contained true /p:PublishSingleFile=true -o bin\Release\net6.0\win-arm64\publish-scd
if errorlevel 1 goto :fail

echo.
echo Build completed!
echo.
echo Output files:
echo   AnyCPU (FDD):           bin\Release\net6.0\publish\WinPlusH-dotNet.exe            (requires .NET 6+ Runtime)
echo   x64 (FDD, single-file): bin\Release\net6.0\win-x64\publish-fdd\WinPlusH-dotNet.exe (requires .NET Runtime)
echo   ARM64 (FDD, single-file): bin\Release\net6.0\win-arm64\publish-fdd\WinPlusH-dotNet.exe (requires .NET Runtime)
echo   x64 (SCD, single-file): bin\Release\net6.0\win-x64\publish-scd\WinPlusH-dotNet.exe (no runtime required)
echo   ARM64 (SCD, single-file): bin\Release\net6.0\win-arm64\publish-scd\WinPlusH-dotNet.exe (no runtime required)

pause
goto :eof

:fail
echo.
echo Build failed. Please check the error above.
exit /b 1
