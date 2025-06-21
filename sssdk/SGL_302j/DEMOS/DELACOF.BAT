COPY C:\Saturn~1\SET_COF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

ECHO Skipping biplane, it's incomplete!
REM cd BIPLANE
REM make clean OBJFMT=coff
REM cd ..

cd CDDA_SGL
make clean OBJFMT=coff
cd ..

cd CHROME
make clean OBJFMT=coff
cd ..

cd FLYING
make clean OBJFMT=coff
cd ..
