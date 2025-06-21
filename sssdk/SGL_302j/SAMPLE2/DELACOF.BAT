COPY C:\Saturn~1\SET_COF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

cd SEGA2D_1
make clean OBJFMT=coff
cd ..

cd SEGA3D_1
make clean OBJFMT=coff
cd ..

cd SEGA3D_2
make clean OBJFMT=coff
cd ..

cd SEGA3D_3
make clean OBJFMT=coff
cd ..
