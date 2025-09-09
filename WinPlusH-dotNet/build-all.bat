@echo off
echo Building WinPlusH-dotNet for multiple deployment options...

echo.
echo Building AnyCPU portable version (recommended)...
dotnet publish -c Release

echo.
echo Building for Windows x64 (single file)...
dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true

echo.
echo Building for Windows ARM64 (single file)...
dotnet publish -c Release -r win-arm64 --self-contained false /p:PublishSingleFile=true

echo.
echo Build completed!
echo.
echo Output files:
echo   AnyCPU: bin\Release\net6.0\publish\WinPlusH-dotNet.exe (requires .NET 6+ Runtime)
echo   x64:    bin\Release\net6.0\win-x64\publish\WinPlusH-dotNet.exe (standalone)
echo   ARM64:  bin\Release\net6.0\win-arm64\publish\WinPlusH-dotNet.exe (standalone)

pause
