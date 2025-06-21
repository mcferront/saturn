echo off
if "%SSSDK%" == "" goto nope

cd build
%SSSDK%/TOOLS/JoEngineCueMaker.exe
cd ..

%SSSDK%/EMU/mednafen-1.29.0-win64/mednafen.exe build\sample.cue
goto done

:nope
echo Please Run set_paths from the Sega Saturn SDK folder (SSSDK)

:done