flex new.l
bison -d TP_COMPIL.y
gcc lex.yy.c TP_COMPIL.tab.c -lfl -ly
a.exe < dec.txt
