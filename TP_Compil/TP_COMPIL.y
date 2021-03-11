%{
   #include<stdio.h>
   #include<stdlib.h> 
   #include <string.h>
   #include <math.h>
   #include "table.h"
   int nb_ligne = 1;
   int nb_col= 1;
   int yylex();   
   int yyerror (char* msg);
   int TYPE1;
%} 
   %union {
           int entier;
           char* str;
		   float real;
           char* type;
           char* booleen;
		   int entier_s;
		   float real_s;
          }
%start DEBUT
%token mc_begin mc_end <type>mc_bool mc_const <type>mc_int <type>mc_float mc_if mc_else mc_for
%token vrg pvg par_o par_f ac_o ac_f plus moins division fois  //et ou non
%token sup inf diff egal supe infe inc dec aff faux
%token <entier>cst_int <real>cst_real <entier_s>cst_int_s <str>idf <booleen>bool_v <real_s>cst_real_s
%type <real>EA
%type <real>COND
%type <real>COMPT
%type <real>CST
//%type <real>OPL
%left plus moins
%left divison fois 
%left inc dec
%%
//l'axiome du début
DEBUT: LISTED mc_begin ALGO mc_end {printf(" le programme est syntaxiquement correct !\n");YYACCEPT;}
;
LISTED: DECC LISTED
       |DECV LISTED
	   |
;

DECC: mc_const TYPE idf aff CST pvg {if (recherche($3)!= -1)
		                                {printf("ERREUR Semantique : l'idf %s existe deja\n",$3);}
		                             else
		                                {inserer($3,"idf",TYPE1,"oui",$5,1);}}		
;
DECV: TYPE idf IDF pvg              {if (recherche($2)!= -1)
		                                {printf("ERREUR Semantique  : l'idf %s existe deja\n",$2);}
		                            else
		                                {inserer($2,"idf",TYPE1,"non",0.0,0);}}
;
//les types 
TYPE: mc_int   {TYPE1=1;}
	 |mc_float {TYPE1=2;}
	 |mc_bool  {TYPE1=3;}
;
//constantes
CST: cst_int  {$$ = $1;}
    |cst_real {$$ = $1;}
	//|bool_v
;
//Pour declarer plusieur identifient
IDF: vrg idf IDF {inserer($2,"idf",TYPE1,"non",0.0,0);}
	|
;
//listes des instruction 
ALGO: AFF   ALGO 
    | IF    ALGO 
	| FOR   ALGO
	| COMPT pvg ALGO
	/*
	| idf inc pvg ALGO {if (recherche($1)==-1) {printf("errer %s n'est pas declare\n", $1);}
	                                            int v=get_type($1);
					                            printf("le  v  %d\n",v); 
					                            if(v==3){printf("Erreur affectation : Incrémentation BOOL");} // ou v==2 aussi
                                                float f = get_val($1);
												f=f+1;
												affect(f,$1);
												}
	| idf dec pvg ALGO {if (recherche($1)==-1) {printf("errer %s n'est pas declare\n", $1);}
	                                            int v=get_type($1);
					                            printf("le  v  %d\n",v); 
					                            if(v==3){printf("Erreur affectation : Incrémentation BOOL");}
                                                float f = get_val($1);
												f=f-1;
												affect(f,$1);
												}
	*/											
	|
;
//affectation
AFF: idf aff EA pvg  {					  
                      if(recherche($1)==-1){printf("ERREUR Semantique  : %s n'est pas declareligne : %d   colonne : %d \n",$1,nb_ligne,nb_col);}
					  if(Change($1)==1){printf("ERREUR Semantique  : changement de constante\nligne : %d   colonne : %d \n",nb_ligne,nb_col);}
					  int v=get_type($1);
					  float z=$3 -floor($3);
					  //printf("L'Edentifient %s <== %f\n",$1,$3);  
					  if(v==3){printf("ERREUR Semantique  : affectation BOOL <== FLOAT\n");}
					  if((v==1)&&(($3 - floor($3) )!=0.0)){printf("ERREUR Semantique  :  INT <== FLOAT ligne : %d   colonne : %d \n",nb_ligne,nb_col);}
					  else{affect($3,$1);} 
					  }
	|idf aff bool_v pvg { 
	                     int g=get_type($1);
		                 if(g!=3){printf("ERREUR Semantique  : de compatibilite de type %s est une variable BOOL \n",$1);}
	                     else{affect_b($1,$3);}
					    }
	|idf aff COND pvg { 
	                     int g=get_type($1);
		                 if(g!=3){printf("ERREUR Semantique  : de compatibilite de type %s est une variable BOOL \n",$1);}
	                     else{affect_bf($3,$1);}
					    }					
;
//Expression Arithmétique
EA:  EA plus EA        { $$ = $1 + $3;} 
    |EA moins EA       { $$ = $1 - $3;}
	|EA fois EA        { $$ = $1 * $3;}
	|EA divison EA     { $$ = $1 / $3; if($3==0){printf("ERREUR Semantique  :  division par zero , ligne : %d   colonne : %d \n",nb_ligne,nb_col );}}
	|cst_int_s         { $$ = $1;}
	|cst_real_s        { $$ = $1;}
	|moins idf         { $$ = -1 * get_val($2);}
	|par_o EA par_f    { $$ = $2;}
	|cst_int           { $$ = $1;}
	|cst_real          { $$ = $1;}
	|idf               { $$ = get_val($1);}
;

//la condition if
IF: mc_if par_o COND par_f ac_o ALGO ac_f
	|mc_if par_o COND par_f ac_o ALGO ac_f mc_else ac_o ALGO ac_f
;
/*
OPL: COND ou COND      {$$ = $1 || $3;}
    |COND et COND      {$$ = $1 && $3;}
    |non COND          {$$ = !$2;}
;
*/

COND:  EA sup   EA      {$$ = $1 >  $3;}
      |EA inf   EA      {$$ = $1 <  $3;}
      |EA diff  EA      {$$ = $1 != $3;}
      |EA egal  EA      {$$ = $1 == $3;}
      |EA supe  EA      {$$ = $1 >= $3;}
      |EA infe  EA      {$$ = $1 <= $3;}
	  //|bool_v          {$$ = get_b($1);} //une fonction qui retourn 0 ou 1
;

//boucle for
FOR: mc_for par_o AFF COND pvg COMPT par_f ac_o ALGO ac_f
;
// compteur 
COMPT: idf inc      {if (recherche($1)==-1) {printf("ERREUR Semantique  : %s n'est pas declare ligne : %d   colonne : %d \n",$1,nb_ligne,nb_col);}
                         int v=get_type($1); 
					     if(v==3){printf("ERREUR Semantique  : affectation Incrémentation BOOL");}
					     float f = get_val($1);
						 f=f+1;
						 affect(f,$1);
                        }
       |idf dec    {if (recherche($1)==-1) {printf("errer %s n'est pas declare\n", $1);}
	                     int v=get_type($1);
					     if(v==3){printf("ERREUR Semantique  : affectation decrementation BOOL");}
                         float f = get_val($1);
					     f=f-1;
						 affect(f,$1);
	                }
;


%%
int yyerror(char *msg){
	int i;
	for(i=0;i<nb_col;i++){printf(" ");}
	printf("^\n");
	for(i=0;i<nb_col;i++){printf(" ");}
	printf("|");
	printf("\nUne erreur syntaxique : \n ");
	printf("                          La ligne %d  \n ",nb_ligne);
	printf("                          La colonne %d  \n ",nb_col);
}
main()
{
yyparse();
afficher();
}
yywrap()
{}

