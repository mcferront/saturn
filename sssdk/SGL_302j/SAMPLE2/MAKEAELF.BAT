COPY C:\Saturn~1\SET_ELF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT

cd SEGA2D_1
make OBJFMT=elf
cd ..

cd SEGA3D_1
make OBJFMT=elf
cd ..

cd SEGA3D_2
make OBJFMT=elf
cd ..

cd SEGA3D_3
make OBJFMT=elf
cd ..
