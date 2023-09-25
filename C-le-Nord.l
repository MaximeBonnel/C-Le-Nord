%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "C-le-Nord.bison.hpp"
%}

%option noyywrap

/* RULES SECTION */
%%
[ \t]+ {/* nothing to be done */} ;
"\n" {return '\n'; } ;

"ajoute" {return INCLUDE; /*includes*/} ;
"lance mi cha" {return MAIN; /*main function*/} ;

"affiche cha" {return PRINT; /*printf*/} ;
"demande cha" {return SCAN; /*scanf*/} ;
"ajoute cha au tableau" {return PUSHBACK; /*.push_back()*/} ;

"hein" {return SEMIC; /*;*/} ;

"che un entier" {return INT; /*int*/} ;
"che un reel" {return FLOAT; /*float*/} ;
"che un caractere" {return CHAR; /*char*/} ;
"che du texte" {return STR; /*string*/;} ;
"che un binaire" {return BOOL; /*bool*/} ;
"che un tableau vide d'entier" {return INTEMPTYTAB; /*int x[]*/} ;
"che un tableau vide de reel" {return FLOATEMPTYTAB; /*float x[]*/} ;
"che un tableau vide de caractere" {return CHAREMPTYTAB; /*char x[]*/} ;
"che un tableau vide de texte" {return STREMPTYTAB; /*string x[]*/} ;
"che un tableau vide de binaire" {return BOOLEMPTYTAB; /*bool x[]*/} ;

"si" {return IF; /*if*/} ;
"tant que" {return WHILE; /*while*/} ;
"pour que" {return FOR; /*for*/} ;

"(" {return OPBRA; /*(*/} ;
")" {return CLBRA; /*)*/} ;
"{" {return LBRACE; /*{*/} ;
"}" {return RBRACE; /*}*/} ;
"vaut" {return EQ; /*==*/} ;
"est plus piti que" {return LT; /*<*/} ;
"est plus grand que" {return GT; /*>*/} ;
"est pareil ou plus piti que" {return LE; /*<=*/} ;
"est pareil ou plus grand que" {return GE; /*>=*/} ;
"est pas pareil que" {return NE; /*!=*/} ;

"je veux dire" {return COMMENT; /*//*/} ;

"et y vaut" {return EQU; /*=*/} ;
"+" {return PLUS; /*+*/} ;
"-" {return MINUS; /*-*/} ;
"*" {return TIMES; /***/} ;
"/" {return DIVIDED; /*/*/} ; 
"++" {return INC; /*++*/} ;
"--" {return DEC; /*--*/} ;

[0-9]+ {yylval.number=atoi(yytext); return NUMBER; /*numbers*/} ;
\"[^\"]*\" {strcpy(yylval.string, yytext); return QUOTSTRING; /*" strings "*/} ;
[-+*&%#_a-zA-Z0-9,.;:]+ {strcpy(yylval.string, yytext); return STRING; /*strings*/} ;
%%