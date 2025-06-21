COPY C:\Saturn~1\SET_ELF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT


cd AKIRA
make OBJFMT=elf
cd ..

cd AKIRA3
make OBJFMT=elf
cd ..

cd DEMOGUN
make OBJFMT=elf
cd ..

cd DEMO_A
make OBJFMT=elf
cd ..

cd DEMO_B
make OBJFMT=elf
cd ..

cd DEMO_C
make OBJFMT=elf
cd ..

cd DEMO_D
make OBJFMT=elf
cd ..

cd DESIGN1
make OBJFMT=elf
cd ..

cd DESIGN2
make OBJFMT=elf
cd ..

cd DESIGN3
make OBJFMT=elf
cd ..

cd DRIVING
make OBJFMT=elf
cd ..

cd DRIVING2
make OBJFMT=elf
cd ..

cd FIGHTING
make OBJFMT=elf
cd ..

cd SAMPSND1
make OBJFMT=elf
cd ..

cd SAMPSND2
make OBJFMT=elf
cd ..

cd SBKLIB
make OBJFMT=elf
cd ..

cd SHOOTING
make OBJFMT=elf
cd ..

cd S_10
make OBJFMT=elf
cd ..

cd S_2_2
make OBJFMT=elf
cd ..

cd S_3_2
make OBJFMT=elf
cd ..

cd S_4_2
make OBJFMT=elf
cd ..

cd S_4_3_1
make OBJFMT=elf
cd ..

cd S_4_3_2
make OBJFMT=elf
cd ..

cd S_4_3_3
make OBJFMT=elf
cd ..

cd S_4_3_4
make OBJFMT=elf
cd ..

cd S_4_5
make OBJFMT=elf
cd ..

cd S_5_2
make OBJFMT=elf
cd ..

cd S_6_3
make OBJFMT=elf
cd ..

cd S_7_2
make OBJFMT=elf
cd ..

cd S_7_4
make OBJFMT=elf
cd ..

cd S_7_6
make OBJFMT=elf
cd ..

cd S_8_10_1
make OBJFMT=elf
cd ..

cd S_8_10_2
make OBJFMT=elf
cd ..

cd S_8_11
make OBJFMT=elf
cd ..

cd S_8_12
make OBJFMT=elf
cd ..

cd S_8_8_1
make OBJFMT=elf
cd ..

cd S_8_8_2
make OBJFMT=elf
cd ..

cd S_8_8_3
make OBJFMT=elf
cd ..

cd S_8_9_1
make OBJFMT=elf
cd ..

cd S_8_9_2
make OBJFMT=elf
cd ..

cd S_9_1
make OBJFMT=elf
cd ..

cd S_CD1
make OBJFMT=elf
cd ..

cd S_CD2
make OBJFMT=elf
cd ..

cd S_CD3
make OBJFMT=elf
cd ..

cd S_CD4
make OBJFMT=elf
cd ..

cd TORUS2
make OBJFMT=elf
cd ..

cd TORUS3
make OBJFMT=elf
cd ..

ECHO Skipping workarea, not with ELF yet.
REM cd WORKAREA
REM make OBJFMT=elf
REM cd ..
