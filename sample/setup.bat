echo off
if "%SSSDK%" == "" call ../sssdk/setup.bat

if not exist build (mkdir build)
echo setup complete
