%{
   #include "TP_COMPIL.tab.h"
   #include  <stdio.h>
   #include  <stdlib.h>
   #include  <string.h>
   extern YYSTYPE yylval;
   extern int nb_col;
   extern int nb_ligne;
%}
idf   [A-Z][a-zA-Z0-9]*("_"[a-zA-Z|0-9]+)*
cste  ([1-9][0-9]*|0) 
cstes [-]([1-9][0-9]*|0)
cstr  {cste}\.[0-9]+
cstrs {cstes}\.[0-9]+
bool_v  "true"|"false"|"TRUE"|"FALSE"

begin "BEGIN"|"begin"
end   "end"|"END"
if    "if"|"IF"
else  "else"|"ELSE"
for   "for"|"FOR"
const "const"|"CONST"
int   "int"|"INT"
float "float"|"FLOAT"
bool  "bool"|"BOOL"
 
plus    "+"
moins    "-"
divison "/"
fois    "*"

vide [ \t]+
%%
{begin} {printf("Flex found BEGIN\n");nb_col+=yyleng;return mc_begin;}
{end}   {printf("Flex found END\n");nb_col+=yyleng;return mc_end;}
{if}    {printf("Flex found IF\n");nb_col+=yyleng;return mc_if;}
{else}  {printf("Flex found ELSE\n");nb_col+=yyleng;return mc_else;}
{for}   {printf("Flex found FOR\n");nb_col+=yyleng;return mc_for;}
{const} {printf("Flex found CONST\n");nb_col+=yyleng;return mc_const;}
{int}   {yylval.type=strdup(yytext);printf("Flex found INT\n");nb_col+=yyleng;return mc_int;}
{float} {yylval.type=strdup(yytext);printf("Flex found FLOAT\n");nb_col+=yyleng;return mc_float;}
{bool}  {yylval.type=strdup(yytext);printf("Flex found BOOL\n");nb_col+=yyleng;return mc_bool;}



">="            {printf("found >=\n");nb_col+=yyleng;return supe; }
"<="            {printf("found <=\n");nb_col+=yyleng;return infe; }
"=="            {printf("found ==\n");nb_col+=yyleng;return egal; }
"<>"            {printf("found <>\n");nb_col+=yyleng;return diff; } 
"<"             {printf("found <\n");nb_col+=yyleng;return inf; } 
">"             {printf("found >\n");nb_col+=yyleng;return sup; } 

":="            {printf("found :=\n");nb_col+=yyleng;return aff;  }
";"             {printf("found ; \n");nb_col+=yyleng;return pvg;  }
","             {printf("found , \n");nb_col+=yyleng;return vrg;  }
{idf} {
        nb_col+=yyleng;
        if(yyleng>10){
            printf("   erreur lexicale: \n   La taille de l identifiant %s doit etre inferieure ou  egale a 10 caracteres\n",yytext);
        }
        else{
		    yylval.str=strdup(yytext);
            printf("Flex found idf \n");
            return idf;
        }   
      }

{cste} { nb_col+=yyleng;
         yylval.entier=atoi(yytext);
         printf("found int cst\n");
         return cst_int;}
		 
{cstes} { nb_col+=yyleng;
         yylval.entier_s=atoi(yytext);
         printf("found int cst signe\n");
         return cst_int_s;}
		 

{cstr} { nb_col+=yyleng;
         yylval.real=atof(yytext);
         printf("found real cst\n");
         return cst_real;}
		 
{cstrs} { nb_col+=yyleng;
         yylval.real_s=atof(yytext);
         printf("found real cst signe\n");
         return cst_real_s;}		 
		 
		 
{bool_v} {nb_col+=yyleng;
          yylval.booleen=strdup(yytext);
          printf("Flex found une variable boolenne \n");
          return bool_v;
          } 
"(" {printf("found '(' \n");return par_o;}
")" {printf("found ')' \n");return par_f;}
"{" {printf("found '{' \n");return ac_o;}
"}" {printf("found '}' \n");return ac_f;}

{plus}    {return plus;}
{moins}   {return moins;}
{divison} {return divison;}
{fois}    {return fois;}


"++"            {printf("found ++\n");nb_col+=yyleng;return inc;}
"--"            {printf("found --\n");nb_col+=yyleng;return dec;}

"/*"(.|\n)[^"*/"]*"*/"  {printf("found COMMENTAIRE\n");nb_col+=yyleng;nb_ligne+=linecpt(yytext);}
[ \t\r]         {nb_col+=yyleng;}
[\n]            {nb_col=0;nb_ligne++;}   
{vide}          {nb_col+=yyleng;}
.               { yyerror("Syntax error\n");}

