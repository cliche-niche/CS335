%option yylineno

%{
    #include <bits/stdc++.h>
    using namespace std;

    vector<string>                  lexemes;        // * Store the order of appearance of lexemes
    unordered_map<string, int>      lexeme_count;   // * Store the count of lexemes
    unordered_map<string, string>   lexeme_token;   // * Store the token of lexemes
%}

WS              [ \t\f\n\r]|\r\n
COMMENT         \{[^\}]*\}
DELIMS          ","|";"|":"|"("|")"|"["|"]"|".."

DIGIT           [0-9]
LETTER          [a-zA-Z]

STRING          \"[^\"]*\"
ID              {LETTER}({LETTER}|{DIGIT})*
NUMBER          {DIGIT}+
FLOAT           {NUMBER}"."{DIGIT}*|{NUMBER}(e|E)("-"|"+")?{NUMBER}

%%

    /* Ignore Comments and Whitespaces */
{COMMENT}|{WS}

    /* Keywords, Operators and Delimiters */
array|begin|case|const|do|downto|else|end|file|for|function|goto|if|label|nil|of|packed|procedure|program|record|repeat|set|then|to|type|until|var|while|with { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Keyword"; } 
                                                                                                                                                                lexeme_count[yytext]++; }
and|or|not|div|mod|in|"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^"  { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Operator"; } 
                                                                                lexeme_count[yytext]++; }
{DELIMS}                { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Separator"; } 
                            lexeme_count[yytext]++; }

    /* Identifiers */
{ID}                    { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Identifier"; } 
                            lexeme_count[yytext]++; }

    /* String, Float, and Integer Literals */
{STRING}                { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Literal"; } 
                            lexeme_count[yytext]++; }
{FLOAT}                 { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Literal"; } 
                            lexeme_count[yytext]++; }
{NUMBER}/({DELIMS}?)    { if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ lexemes.push_back(yytext); lexeme_token[yytext] = "Literal"; } 
                            lexeme_count[yytext]++; }

    /* Invalid Literals */
"."{NUMBER}             { cerr<<"Invalid literal \""<<yytext<<"\" found at line number "<<yylineno<<"\nTerminating...\n"; exit(1);}
\"                      { cerr<<"Found a dangling \" at line number "<<yylineno<<"\nPossible reason: Multiline string\nTerminating...\n\n"; exit(1); }
.                       { cerr<<"Invalid character ("<<yytext<<") found at line number "<<yylineno<<"\nTerminating...\n"; exit(1);}

%%

int main(){    
    yylex();

    cout<<"Lexeme,Token,Count\n";
    for(auto lexeme : lexemes){
        cout<<lexeme<<","<<lexeme_token[lexeme]<<","<<lexeme_count[lexeme]<<'\n';
    }

    return 0;
}