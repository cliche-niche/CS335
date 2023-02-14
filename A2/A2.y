%{
    #include <bits/stdc++.h>
    using namespace std;

    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;

    void yyerror(const char *s);

    extern int yylineno;
    extern string title;
    extern vector< string > chapters;
    extern vector< vector < string > > sections;
    extern int words, decla, excla, inter;
%}

%token TITLE CHAPTER SECTION 
%token WORD NUMBER 
%token WHITESPACE SEMIC COMMA PUNCS
%token PERIOD EXCLAMATION QUESTION 
%token NEW_LINE

%%

dis:
    TITLE nl cha_more cha_end
;

/* One chapter */
cha:
    CHAPTER NEW_LINE nl sec sec_more
|   CHAPTER NEW_LINE nl par par_more   
;

/* Last chapter */
cha_end:
    CHAPTER NEW_LINE nl sec_more sec_end
|   CHAPTER NEW_LINE nl par_more par_end
;

/* For more than one chapters */
cha_more:
    %empty
|   cha cha_more
;

sec:
    SECTION NEW_LINE nl par par_more
;

sec_end:
    SECTION NEW_LINE nl par_more par_end
;

sec_more:
    %empty
|   sec sec_more
;

par:
    sen NEW_LINE NEW_LINE
|   sen w_s sen_more
;

par_end:
    sen nl
|   sen w_s par_end
;

par_more:
    %empty
|   par par_more
;

sen_more:
    sen NEW_LINE NEW_LINE
|   sen w_s sen_more
;

sen:
    dec
|   exc
|   inte 
;

dec:
    word w_s cont PERIOD
|   word w_s COMMA cont PERIOD
|   word COMMA w_s cont PERIOD
|   word w_s COMMA w_s cont PERIOD
|   word w_s SEMIC cont PERIOD
|   word SEMIC w_s cont PERIOD
|   word w_s SEMIC w_s cont PERIOD
;

exc:
    word w_s cont EXCLAMATION
|   word w_s COMMA cont EXCLAMATION
|   word COMMA w_s cont EXCLAMATION
|   word w_s COMMA w_s cont EXCLAMATION
|   word w_s SEMIC cont EXCLAMATION
|   word SEMIC w_s cont EXCLAMATION
|   word w_s SEMIC w_s cont EXCLAMATION
;

inte:
    word w_s cont QUESTION
|   word w_s COMMA cont QUESTION
|   word COMMA w_s cont QUESTION
|   word w_s COMMA w_s cont QUESTION
|   word w_s SEMIC cont QUESTION
|   word SEMIC w_s cont QUESTION
|   word w_s SEMIC w_s cont QUESTION
;

cont:
    %empty
|   word w_s cont
|   word w_s COMMA cont
|   word COMMA w_s cont
|   word w_s COMMA w_s cont
|   word w_s SEMIC cont
|   word SEMIC w_s cont
|   word w_s SEMIC w_s cont
;

word:
    WORD
|   NUMBER
;

nl:
    %empty
|   NEW_LINE nl
;

w_s:
    %empty
|   WHITESPACE w_s
;


%%

int main(){
    cout<<"hello";
    
    yyin = fopen("s.txt", "r");
    
    yyparse();

    cout<<chapters.size();
}

void yyerror(const char *s){
    
    cout<<"\nError found at line number: "<<yylineno<<"\n\nTerminating...\n";
    exit(1);
}