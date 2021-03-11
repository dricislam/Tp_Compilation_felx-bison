 //fonction recherche
int recherche(char entite[]);

typedef struct
{char NomEntite[20];
 char CodeEntite[20];
 int  TypeEntite;
 char Constant[20];
 char valb[20];
 float val;
 int is_Set;}TypeTS;

 TypeTS ts[100];
 int CpTabSym=0;
 int CptT=0;
 
 typedef struct
 {
	 char type[20];
 }TypeT;
 
  TypeT T[100];

 void affect(float v,char entite[])
 {  int m=0;
	 m= recherche(entite);
	 ts[m].val = v;
	 ts[m].is_Set = 1;
 }
 
 //affecter bool
  void affect_b(char entite[],char entite1[])
 {  int m=0;
	 m= recherche(entite);
	 strcpy(ts[m].valb,entite1);
	 ts[m].is_Set = 1;
 }

//affecter bool apartir d un float 
 void affect_bf(float v,char entite[])
 {  int m=0;
	 m= recherche(entite);
	 if(v==0){strcpy(ts[m].valb,"false");}
	 if(v==1){strcpy(ts[m].valb,"true");}
	 ts[m].is_Set = 1;
 }
 
 float get_val(char c[]){
	 int i=recherche(c);
	 printf("i : %d \n",i);
	 if(i==-1){printf("%s n'est pas declare\n",ts[i].NomEntite);}
	 if((ts[i].is_Set==0)||(ts[i].TypeEntite==3))
	 {if(ts[i].is_Set==0){printf("%s n'est pas initaliser\n",ts[i].NomEntite);}
      if(ts[i].TypeEntite==3){printf("Erreur, pas de booleen dans l'expression arithmetique\n ");}
	  return 0;
	 } 
	 else{return ts[i].val;};
 }
 


 
//donne le Type d un IDF
int get_type(char entite[])
{ int i=0;
  i= recherche(entite);
return ts[i].TypeEntite;
}
//


 //fonction inserer 
 void inserer(char entite[],char code[],int type,char c[],float vl,int s)
 {if (recherche(entite)==-1)
  {strcpy(ts[CpTabSym].NomEntite,entite);
   strcpy(ts[CpTabSym].CodeEntite,code);
   ts[CpTabSym].TypeEntite=type;
   strcpy(ts[CpTabSym].Constant,c);
   
   if(type==3){strcpy(ts[CpTabSym].valb,"false");}
   else{ts[CpTabSym].val=vl;}
   
   ts[CpTabSym].is_Set=s;
   CpTabSym++;
  }else{printf("idf : %s existe deja\n",entite);  };
 }
 //changement de constatnte 
 int Change(char entite[])
 {
	 int i=0;
	 while(i<CpTabSym)
	 {
		 if((strcmp(entite,ts[i].NomEntite)==0) && strcmp("oui",ts[i].Constant)==0) 
		 {return 1;}
		 i++;	 
	 }
	 return 0;
 }

 
 // fonction afficher table de Symboles
 void afficher ()
{
	printf("\n\t/***********************************************Table des symboles *************************************************/\n");
	printf("\t_______________________________________________________________________________________________________________________\n");
	printf("\t|     N*      |  NomEntite  |  CodeEntite  |  TypeEntite  |  ConstEntite  |  ValeurFloat  |  ValeurBOOL  |   Is_SET   |\n");
	printf("\t_______________________________________________________________________________________________________________________\n");
    char tem[10];
	int i=0;
	/*tant que l'indice est inferieur au flux de carctères */
	while(i<CpTabSym) 
	{  if(ts[i].TypeEntite==1){strcpy(tem,"int");}
	   if(ts[i].TypeEntite==2){strcpy(tem,"float");}
	   if(ts[i].TypeEntite==3){strcpy(tem,"bool");}
	   
	printf("\t|%12d |%12s |%12s  |%12s  |%12s   |%12f   |%12s   |%12d   |\n",i+1,ts[i].NomEntite,ts[i].CodeEntite,tem,ts[i].Constant,ts[i].val,ts[i].valb,ts[i].is_Set);
	i++;
	}
	printf("\t__________________________________________________________________________________________________________________________\n");
}

 
 //fonction recherche
int recherche(char entite[])
{ int i=0;
 while(i<CpTabSym)
 {if(strcmp(entite,ts[i].NomEntite)==0){return i;}
 i++;
 }
 return -1;
}


int linecpt(char comment[])
{
   int l=1;
   int i;
   for (i =0; comment[i] != '\0' ; ++i)
   {
     if (comment[i] == '\n')
     {
       l++;
     }
   }
   return l-1;
}

