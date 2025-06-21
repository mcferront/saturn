COPY C:\Saturn~1\SET_ELF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

ECHO Skipping biplane, it's incomplete!
REM cd BIPLANE
REM make OBJFMT=elf
REM cd ..

cd CDDA_SGL
make OBJFMT=elf
cd ..

cd CHROME
make OBJFMT=elf
cd ..

cd FLYING
make OBJFMT=elf
cd ..
