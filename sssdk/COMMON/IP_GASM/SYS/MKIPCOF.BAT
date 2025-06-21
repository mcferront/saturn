COPY C:\Saturn~1\SET_COF.BAT .\TMP.BAT
CALL TMP.BAT
DEL TMP.BAT
make clean OBJFMT=coff
ECHO make can't call gasm.bat correctly, so this bat file does instead
CALL gasm sys_id.src  -o sys_id.o
make OBJFMT=coff
