COPY C:\Saturn~1\SET_ELF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

ECHO Skipping biplane, it's incomplete!
REM cd BIPLANE
REM make clean OBJFMT=elf
REM cd ..

cd CDDA_SGL
make clean OBJFMT=elf
cd ..

cd CHROME
make clean OBJFMT=elf
cd ..

cd FLYING
make clean OBJFMT=elf
cd ..
