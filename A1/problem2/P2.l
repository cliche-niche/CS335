%option yylineno

%{
    #include <bits/stdc++.h>
    using namespace std;

    vector<string>                  lexemes;        // * Store the order of appearance of lexemes
    unordered_map<string, int>      lexeme_count;   // * Store the count of lexemes
    unordered_map<string, string>   lexeme_token;   // * Store the token of lexemes

    string                          text_block;     // * Store content of Text Block
    int                             tb_start;       // * Store starting line of Text Block (for error reporting purposes)
%}


WS              [ \t\f]
LT              [\n\r]|(\r\n)

INPUT_CHAR      [^\n\r]        
COMMENT         "/*"([^*]|{LT})*"*"((([^*/]|{LT})([^*]|{LT})*)?"*")*"/"|"//"{INPUT_CHAR}*{LT}*

THREE_QUOTES    \"\"\"
%x              TEXT_BLOCK_WS
%x              TEXT_BLOCK_TB

SEPARATOR       "("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::"
OPERATOR        "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
CHARACTER       ['][^\r\n\'\\][']
STRING          \"[^\r\n\"]*\"
NZ_DIGIT        [1-9]
DIGIT           [0-9]
DIGITS          {DIGIT}((\_)*{DIGIT})*
HEX_DIGIT       [0-9a-fA-F]
HEX_DIGITS      {HEX_DIGIT}((\_)*{HEX_DIGIT})*
EXPONENT        [eE]("+"|"-")?{DIGITS}
ID              [a-zA-Z\_\$][a-zA-Z0-9\_\$]*

BINARY          0[bB][01]((\_)*[01])*[lL]?
OCTAL           0((\_)*[0-7])*[lL]?
DECIMAL         (0|{NZ_DIGIT}((\_)*{DIGIT})*)[lL]?
HEXADECIMAL     0[xX]{HEX_DIGIT}((\_)*{HEX_DIGIT})*[lL]?

DECIMAL_FP      ({DIGITS}"."{DIGITS}?{EXPONENT}?[dfDF]?)|("."{DIGITS}{EXPONENT}?[dfDF]?)|({DIGITS}{EXPONENT}[dfDF]?)|({DIGITS}{EXPONENT}?[dfDF])
HEXADECIMAL_FP  ({HEXADECIMAL}(".")?|(0[xX]{HEX_DIGITS}?"."{HEX_DIGITS}))[pP](("-"|"+")?{DIGITS})[dfDF]?

%%
    /* Eat up Comments, Whitespaces, and Line Terminators */
{COMMENT}|{WS}|{LT}

    /* Keywords, Separators, and Operators */
abstract|continue|for|new|switch|assert|default|if|package          {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
synchronized|boolean|do|goto|private|this|break|double|implements   {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
protected|throw|byte|else|import|public|throws|case|enum|instanceof {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
return|transient|catch|extends|int|short|try|char|final|interface   {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
static|void|class|finally|long|strictfp|volatile|const|float|native {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
super|while|\_|exports|opens|requires|uses|module|permits|sealed    {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
var|non\-sealed|provides|to|with|open|record|transitive|yield       {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                                            lexemes.push_back(yytext); 
                                                                            lexeme_token[yytext] = "Keyword";
                                                                        } 
                                                                        lexeme_count[yytext]++;  
                                                                    }
{SEPARATOR}                                 {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Separator";
                                                } 
                                                lexeme_count[yytext]++;  
                                            }
{OPERATOR}                                  {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Operator";
                                                } 
                                                lexeme_count[yytext]++;  
                                            }

    /* Numeric Literals */
{BINARY}|{OCTAL}|{DECIMAL}|{HEXADECIMAL}    {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Literal";
                                                } 
                                                lexeme_count[yytext]++;  
                                            }

    /* Floating Point literals */
{DECIMAL_FP}|{HEXADECIMAL_FP}               {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Literal";
                                                } 
                                                lexeme_count[yytext]++; 
                                            }

    /* Null and Boolean Literals*/
null|true|false                             {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Literal";
                                                } 
                                                lexeme_count[yytext]++; 
                                            }

    /* Text Blocks*/
{THREE_QUOTES}                              {
                                                BEGIN(TEXT_BLOCK_WS);
                                                text_block = yytext;
                                                tb_start = yylineno;
                                            }
<TEXT_BLOCK_WS,TEXT_BLOCK_TB><<EOF>>        {
                                                cerr<<"Unclosed Text Block at line number: "<<tb_start<<"\nTerminating..\n\n";
                                                exit(1);
                                            }
<TEXT_BLOCK_TB>{THREE_QUOTES}               {
                                                text_block += yytext;
                                                if(find(lexemes.begin(), lexemes.end(), text_block) == lexemes.end()){ 
                                                    lexemes.push_back(text_block); 
                                                    lexeme_token[text_block] = "Literal";
                                                }
                                                lexeme_count[text_block]++; 
                                                text_block = "";
                                                BEGIN(INITIAL);
                                            }
<TEXT_BLOCK_WS>{LT}                         {
                                                text_block += yytext;                                            
                                                BEGIN(TEXT_BLOCK_TB);
                                            }
<TEXT_BLOCK_WS>{WS}*                        {
                                                text_block += yytext;                                            
                                            }
<TEXT_BLOCK_WS>.                            {
                                                cerr<<"Error in text block at line number "<<yylineno<<"\nTerminating...\n\n";
                                                exit(1);
                                            }
<TEXT_BLOCK_TB>(.|{LT})                     {
                                                text_block += yytext;  
                                            }

    /* Characters and Strings */
{CHARACTER}|{STRING}                        {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Literal";
                                                } 
                                                lexeme_count[yytext]++; 
                                            }

    /* Identifiers */
{ID}                                        {   if(find(lexemes.begin(), lexemes.end(), yytext) == lexemes.end()){ 
                                                    lexemes.push_back(yytext); 
                                                    lexeme_token[yytext] = "Identifier";
                                                } 
                                                lexeme_count[yytext]++; 
                                            }

    /* Report unclosed Strings, Characters, and illegal/bad characters */
[\"\']                                      {   cerr<<"Found a dangling ("<<yytext<<") at line number "<<yylineno<<"\nPossible reason: Multiline string\nTerminating...\n\n"; exit(1); }
.                                           {   cerr<<"Bad character ("<<yytext<<") found at line number "<<yylineno<<"\nTerminating...\n\n"; exit(1); } 

%%

int main(){    
    yylex();

    cout<<"Lexeme,Token,Count\n";
    for(auto lexeme : lexemes){
        cout<<lexeme<<","<<lexeme_token[lexeme]<<","<<lexeme_count[lexeme]<<'\n';
    }

    return 0;
}