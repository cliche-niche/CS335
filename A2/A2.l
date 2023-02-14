%{
    #include <bits/stdc++.h>
    using namespace std;
    
    #include "A2.tab.h"

    string title = "";
    vector< string > chapters;
    vector< vector < string > > sections;
    int words = 0, decla = 0, excla = 0, inter = 0;
%}

WS              [ \t\f]
PUNCS           "."|","|"!"|":"|";"|"?"
WORD_SEP        {WS}|","|";"        

DIGIT           [0-9]
LETTER          [a-zA-Z]

NUMBER          {DIGIT}+|{DIGIT}*"."{DIGIT}+
WORD            {LETTER}+

%%

"Title"{WS}+":"{WS}*[^\n]+                   {   title = yytext; return (TITLE); }
"Title"{WS}*":"{WS}+[^\n]+                   {   title = yytext; return (TITLE); }
"Chapter"{WS}*{NUMBER}{WS}+":"{WS}*[^\n]+    {   chapters.push_back(yytext); return (CHAPTER); }
"Chapter"{WS}*{NUMBER}{WS}*":"{WS}+[^\n]+    {   chapters.push_back(yytext); return (CHAPTER); }
"Section"{WS}*{NUMBER}{WS}*":"{WS}+[^\n]+    {   if(chapters.size() > 0){
                                                sections[chapters.size()-1].push_back(yytext); return (SECTION);
                                            }else{
                                                cout<<"\nError: Section started without a Chapter at line number: "<<yylineno<<"\n\nTerminating...\n"; exit(1);
                                            }
                                        }
"Section"{WS}*{NUMBER}{WS}+":"{WS}*[^\n]+    {   if(chapters.size() > 0){
                                                sections[chapters.size()-1].push_back(yytext); return (SECTION);
                                            }else{
                                                cout<<"\nError: Section started without a Chapter at line number: "<<yylineno<<"\n\nTerminating...\n"; exit(1);
                                            }
                                        }
{WORD}                                  {   words++; return (WORD); }
{NUMBER}                                {   return (NUMBER); }
{WS}                                    {   return (WHITESPACE); }
"."                                     {   decla++; return (PERIOD); }
"!"                                     {   excla++; return (EXCLAMATION); }
"?"                                     {   inter++; return (QUESTION); }
";"                                     {   return (SEMIC); }
","                                     {   return (COMMA); }
{PUNCS}                                 {   return (PUNCS); }
"\n"                                    {   return (NEW_LINE); }
.


%%

// int main(){

//     yylex();

//     return 0;
// }

int yywrap(){
    return 1;
}