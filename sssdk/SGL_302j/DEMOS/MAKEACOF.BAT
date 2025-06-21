COPY C:\Saturn~1\SET_COF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

ECHO Skipping biplane, it's incomplete!
REM cd BIPLANE
REM make OBJFMT=coff
REM cd ..

cd CDDA_SGL
make OBJFMT=coff
cd ..

cd CHROME
make OBJFMT=coff
cd ..

cd FLYING
make OBJFMT=coff
cd ..
