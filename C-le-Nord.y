%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <iostream>
    #include <fstream>
    #include <string>
    #include <cstring>
    #include <vector>

    #define YYDEBUG 1

    extern int yylex ();
    extern char* yytext;
    extern FILE *yyin;
    int yyerror(char *s);

    using namespace std;

    // VARIABLES
    vector<string> includeTab;
    vector<string> programTab;

    // IF
    int ifLoop = false;
    vector<vector<string>> ifTab(10, vector<string>()); // 10 nested if max

    // WHILE
    int whileLoop = false;
    vector<vector<string>> whileTab(10, vector<string>()); // 10 nested while max

    // FOR
    int forLoop = false;
    vector<vector<string>> forTab(10, vector<string>()); // 10 nested for max 
%}

%code requires
{
    #define STRINGSIZE 256
}

%union
{
    double number;
    char string[STRINGSIZE];
}

// TYPE RULES
%type <string> instruction
%type <string> ifRule
%type <string> endIfRule
%type <string> whileRule
%type <string> endWhileRule
%type <string> forRule
%type <string> endForRule
%type <string> type
%type <string> expr

// NUMBERS / STRINGS
%token <number> NUMBER
%token <string> STRING
%token <string> QUOTSTRING

// TOKENS SECTION
// HELP
%token HELP

// INSTRUCTIONS
%token INCLUDE MAIN

// FUNCTIONS
%token PRINT SCAN PUSHBACK

// CHARACTERS
%token OPBRA CLBRA LBRACE RBRACE SEMIC COMMENT

// TYPES
%token INT FLOAT CHAR  STR BOOL INTEMPTYTAB FLOATEMPTYTAB CHAREMPTYTAB STREMPTYTAB BOOLEMPTYTAB

// INSTRUCTION
%token IF WHILE FOR

// COMPARATORS
%token EQ NE GE LE GT LT

// OPERATORS
%token EQU PLUS MINUS TIMES DIVIDED INC DEC

%%
// RULES SECTION
program: line MAIN OPBRA CLBRA LBRACE line RBRACE{
    programTab.insert(programTab.begin(), "int main(int argc, char** argv){");
    programTab.push_back("}");
    printf ("Le programme y est bien hein\n");
} ;

line: {} ;
    | line '\n' {} ;
    | line instruction '\n' {};
    | line HELP {printf("aide\n");} ;

instruction: INCLUDE STRING SEMIC {strcpy($$, ""); strcat($$, "#include <"); strcat($$, $2); strcat($$, ">"); includeTab.push_back($$);} ;
    | PRINT QUOTSTRING SEMIC {strcpy($$, ""); strcat($$, "\tprintf("); strcat($$, $2); strcat($$, ");"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | SCAN QUOTSTRING STRING SEMIC {strcpy($$, ""); strcat($$, "\tscanf("); strcat($$, $2); strcat($$, ", &"); strcat($$, $3); strcat($$, ");"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;

    | STRING type SEMIC {strcpy($$, ""); strcat($$, $2); strcat($$, $1); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING type EQU NUMBER SEMIC {strcpy($$, ""); strcat($$, $2); strcat($$, $1); strcat($$, " = "); strcat($$, to_string($4).c_str()); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING type EQU STRING SEMIC {strcpy($$, ""); strcat($$, $2); strcat($$, $1); strcat($$, " = \""); strcat($$, $4); strcat($$, "\";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING type EQU QUOTSTRING SEMIC {strcpy($$, ""); strcat($$, $2); strcat($$, $1); strcat($$, " = "); strcat($$, $4); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING type EQU expr SEMIC {strcpy($$, ""); strcat($$, $2); strcat($$, $1); strcat($$, " = "); strcat($$, $4); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING EQU expr SEMIC {strcpy($$, "\t"); strcat($$, $1); strcat($$, " = "); strcat($$, $3); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING EQU STRING SEMIC {strcpy($$, "\t"); strcat($$, $1); strcat($$, " = "); strcat($$, $3); strcat($$, ";"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;

    | COMMENT QUOTSTRING SEMIC {strcpy($$, ""); strcat($$, "\t// "); strcat($$, $2); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;

    | STRING PUSHBACK QUOTSTRING SEMIC{strcpy($$, "\t"); strcat($$, $1); strcat($$, ".push_back("); strcat($$, $3); strcat($$, ");"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING PUSHBACK STRING SEMIC{strcpy($$, "\t"); strcat($$, $1); strcat($$, ".push_back("); strcat($$, $3); strcat($$, ");"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;
    | STRING PUSHBACK NUMBER SEMIC{strcpy($$, "\t"); strcat($$, $1); strcat($$, ".push_back("); strcat($$, to_string($3).c_str()); strcat($$, ");"); if(ifLoop != false){ifTab[ifLoop].push_back($$);} else if(whileLoop != false){whileTab[whileLoop].push_back($$);} else if(forLoop != false){forTab[forLoop].push_back($$);} else {programTab.push_back($$);}} ;

    | ifRule LBRACE line endIfRule {} ;

    | whileRule LBRACE line endWhileRule {} ;

    | forRule LBRACE line endForRule {} ;

ifRule: IF STRING EQ STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " == "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;
    | IF STRING LT STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " < "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;
    | IF STRING GT STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " > "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;
    | IF STRING LE STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " <= "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;
    | IF STRING GE STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " >= "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;
    | IF STRING NE STRING {ifLoop++; strcpy($$, ""); strcat($$, "if("); strcat($$, $2); strcat($$, " != "); strcat($$, $4); strcat($$, "){"); ifTab[ifLoop].push_back($$);} ;

endIfRule: RBRACE {ifTab[ifLoop].push_back("}"); if(ifLoop > 1){ for(string line : ifTab[ifLoop]){ifTab[ifLoop-1].push_back('\t' + line);}} else { for(string line : ifTab[ifLoop]){programTab.push_back('\t' + line);}} ifTab[ifLoop].clear(); ifLoop--;} ;

whileRule: WHILE STRING EQ STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " == "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;
    | WHILE STRING LT STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " < "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;
    | WHILE STRING GT STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " > "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;
    | WHILE STRING LE STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " <= "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;
    | WHILE STRING GE STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " >= "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;
    | WHILE STRING NE STRING {whileLoop++; strcpy($$, ""); strcat($$, "while("); strcat($$, $2); strcat($$, " != "); strcat($$, $4); strcat($$, "){"); whileTab[whileLoop].push_back($$);} ;

endWhileRule: RBRACE {whileTab[whileLoop].push_back("}"); if(whileLoop > 1){ for(string line : whileTab[whileLoop]){whileTab[whileLoop-1].push_back('\t' + line);}} else { for(string line : whileTab[whileLoop]){programTab.push_back('\t' + line);}} whileTab[whileLoop].clear(); whileLoop--;} ;

forRule: FOR STRING type EQU NUMBER SEMIC STRING EQ STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " == "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;
    | FOR STRING type EQU NUMBER SEMIC STRING LT STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " < "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;
    | FOR STRING type EQU NUMBER SEMIC STRING GT STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " > "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;
    | FOR STRING type EQU NUMBER SEMIC STRING LE STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " <= "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;
    | FOR STRING type EQU NUMBER SEMIC STRING GE STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " >= "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;
    | FOR STRING type EQU NUMBER SEMIC STRING NE STRING SEMIC expr {forLoop++; strcpy($$, ""); strcat($$, "for("); strcat($$, $3); strcat($$, $2); strcat($$, " = "); strcat($$, to_string($5).c_str()); strcat($$, "; "); strcat($$, $7); strcat($$, " != "); strcat($$, $9); strcat($$, "; "); strcat($$, $11); strcat($$, "){"); forTab[forLoop].push_back($$);} ;

endForRule: RBRACE {forTab[forLoop].push_back("}"); if(forLoop > 1){ for(string line : forTab[forLoop]){forTab[forLoop-1].push_back('\t' + line);}} else { for(string line : forTab[forLoop]){programTab.push_back('\t' + line);}} forTab[forLoop].clear(); forLoop--;} ;

type: INT {strcpy($$, ""); strcat($$, "\tint ");} ;
    | FLOAT {strcpy($$, ""); strcat($$, "\tdouble ");} ;
    | CHAR {strcpy($$, ""); strcat($$, "\tchar ");} ;
    | STR {strcpy($$, ""); strcat($$, "\tstd::string ");} ;
    | BOOL {strcpy($$, ""); strcat($$, "\tbool ");} ;
    | INTEMPTYTAB {strcpy($$, ""); strcat($$, "\tstd::vector<int> ");} ;
    | FLOATEMPTYTAB {strcpy($$, ""); strcat($$, "\tstd::vector<double> ");} ;
    | CHAREMPTYTAB {strcpy($$, ""); strcat($$, "\tstd::vector<char> ");} ;
    | STREMPTYTAB {strcpy($$, ""); strcat($$, "\tstd::vector<std::string> ");} ;
    | BOOLEMPTYTAB {strcpy($$, ""); strcat($$, "\tstd::vector<bool> ");} ;

expr: NUMBER PLUS NUMBER {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, " + "); strcat($$, to_string($3).c_str());} ;
    | NUMBER MINUS NUMBER {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, " - "); strcat($$, to_string($3).c_str());} ;
    | NUMBER TIMES NUMBER {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, " * "); strcat($$, to_string($3).c_str());} ;
    | NUMBER DIVIDED NUMBER {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, " / "); strcat($$, to_string($3).c_str());} ;
    | NUMBER INC {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, "++");} ;
    | NUMBER DEC {strcpy($$, ""); strcat($$, to_string($1).c_str()); strcat($$, "--");} ;

    | STRING PLUS STRING {strcpy($$, ""); strcat($$, $1); strcat($$, " + "); strcat($$, $3);} ;
    | STRING MINUS STRING {strcpy($$, ""); strcat($$, $1); strcat($$, " - "); strcat($$, $3);} ;
    | STRING TIMES STRING {strcpy($$, ""); strcat($$, $1); strcat($$, " * "); strcat($$, $3);} ;
    | STRING DIVIDED STRING {strcpy($$, ""); strcat($$, $1); strcat($$, " / "); strcat($$, $3);} ;
    | STRING INC {strcpy($$, ""); strcat($$, $1); strcat($$, "++");} ;
    | STRING DEC {strcpy($$, ""); strcat($$, $1); strcat($$, "--");} ;
%%

int yyerror(char *s) {
    printf("Ya une erreur là mon grand\n");					
    printf("%s : %s\n", s, yytext);
    return 0;
}

int main(int argc, char** argv) {
    //yydebug = 1;	
    printf("\n\nC le Nord V1.0\n");

    if ( argc > 1 ){
        yyin = fopen( argv[1], "r" );
    } else {
        yyin = stdin;
    }

    yyparse();

    // Writing in file
    ofstream file("generatedCode.cpp");
    if (file.is_open()) {
        // always add vector and string to include
        includeTab.push_back("#include <string>");
        includeTab.push_back("#include <vector>");
        // Includes
        for (string line : includeTab) {
            file << line << endl;
        }
        file << endl;

        // Program
        for (string line : programTab) {
            file << line << endl;
        }
        file.close();
    } else {
        std::cout << "Erreur lors de l'ouverture du fichier." << std::endl;
    }

    return 0;
}