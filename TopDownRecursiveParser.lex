/**
 * Top-down recursive lexer and parser 
 * 
 * It contains a lexical analyzer using Flex (fast lexical analyzer generator)
 * that recognizes the following tokens:
 * 
 *      - reserved words
 *      - symbols
 *      - floating-point numbers
 *      - integer numbers
 *      - identifiers (names)
 * 
 * It also contains a syntax analyzer for a given grammar.
 * 
 * @author Salvador Orozco Villalever - A07104218
 * @version 09/13/2018
 * 
 * Instructions for compiling and executing the program:
 * 
 * 1. flex <PATH_TO_LEX_FILE>
 * 2. gcc <PATH_TO_ "lex.yy.c" FILE> -ll
 * 3. ./a.out
 */ 

%{
/* Reserved words */
#define RES_WORD_FUNCTION       0
#define RES_WORD_PROCEDURE      1
#define RES_WORD_FOR            2
#define RES_WORD_WHILE          3
#define RES_WORD_DO             4
#define RES_WORD_BEGIN          5
#define RES_WORD_END            6
#define RES_WORD_REPEAT         7
#define RES_WORD_UNTIL          8
#define RES_WORD_PROGRAM        9
#define RES_WORD_SET            10
#define RES_WORD_IF             11
#define RES_WORD_IFELSE         12

/* Symbols */
#define SYMBOL_COLON_EQ         100 
#define SYMBOL_EQ               101                                          
#define SYMBOL_LT               102                                    
#define SYMBOL_GT               103                                          
#define SYMBOL_SEMI_COLON       104                                            
#define SYMBOL_COMMA            105                                           
#define SYMBOL_COLON            106                                          
#define SYMBOL_LEQ              107                                       
#define SYMBOL_GEQ              108                                            
#define SYMBOL_NEQ              109
#define SYMBOL_PLUS             110
#define SYMBOL_MINUS            111
#define SYMBOL_STAR             112
#define SYMBOL_FORWARD_SLASH    113
#define SYMBOL_LT_PARENTHESES   114
#define SYMBOL_RT_PARENTHESES   115
#define SYMBOL_LT_BRACKET       116
#define SYMBOL_RT_BRACKET       117
#define SYMBOL_SPACE            118

/* Integer numbers */
#define INTEGER_NUMBER          200

/* Floating-point numbers */
#define FLOATING_POINT_NUMBER   300

/* Identifiers */
#define IDENTIFIER              400

/* End-of-file */
#define END_OF_FILE             -100

/* Anything else */
#define UNKNOWN_TOKEN           1100

#define TOKEN_CATEGORY_SIZE     100
%} 

DIGIT       [0-9]
DIGITWZ     [1-9]
LETTER      [a-zA-Z]
%%
function                                                { return RES_WORD_FUNCTION; } /* Reserved words */
procedure                                               { return RES_WORD_PROCEDURE; }
for                                                     { return RES_WORD_FOR; }
while                                                   { return RES_WORD_WHILE; }
do                                                      { return RES_WORD_DO; }
begin                                                   { return RES_WORD_BEGIN; }
end                                                     { return RES_WORD_END; }
repeat                                                  { return RES_WORD_REPEAT; }
until                                                   { return RES_WORD_UNTIL; }
program                                                 { return RES_WORD_PROGRAM; }
set                                                     { return RES_WORD_SET; }
if                                                      { return RES_WORD_IF; }
ifelse                                                  { return RES_WORD_IFELSE; }

":="                                                    { return SYMBOL_COLON_EQ; } /* Symbols */
"="                                                     { return SYMBOL_EQ; }
"<"                                                     { return SYMBOL_LT; }
">"                                                     { return SYMBOL_GT; }
";"                                                     { return SYMBOL_SEMI_COLON; }
","                                                     { return SYMBOL_COMMA; }
":"                                                     { return SYMBOL_COLON; }
"<="                                                    { return SYMBOL_LEQ; }
">="                                                    { return SYMBOL_GEQ; }
"!="                                                    { return SYMBOL_NEQ; }
"+"                                                     { return SYMBOL_PLUS; }
"-"                                                     { return SYMBOL_MINUS; }
"*"                                                     { return SYMBOL_STAR; }
"/"                                                     { return SYMBOL_FORWARD_SLASH; }
"("                                                     { return SYMBOL_LT_PARENTHESES; }
")"                                                     { return SYMBOL_RT_PARENTHESES; }
"{"                                                     { return SYMBOL_LT_BRACKET; }
"}"                                                     { return SYMBOL_RT_BRACKET; }

("-")?({DIGITWZ}{DIGIT}*|"0")                           { return INTEGER_NUMBER; } /* Integer numbers */

("-")?(({DIGITWZ}{DIGIT}*|"0")"."({DIGIT}*{DIGIT}))     { return FLOATING_POINT_NUMBER; } /* Floating-point numbers */

("$"|{LETTER}|"_")("$"|{LETTER}|"_"|{DIGIT})*           { return IDENTIFIER; } /* Identifiers */

<<EOF>>                                                 { return END_OF_FILE; } /* End-of-file */

[/]+.*                                                  { printf(""); } /* Comment */

" "                                                     { return SYMBOL_SPACE; }

.                                                       { return 1100; } /* Anything else */
%%

// ################# LEXICAL ANALIZER #################

/**
 * Function that handles the printing of codes for reserved words.
 * 
 * @param reservedWordCode the code of the reserved word to handle
 * @returns the code of the reserved word to handle 
 */ 
int getReservedWordCode(int reservedWordCode){

    return reservedWordCode;
}

/**
 * Function that handles the printing of codes for symbols.
 * 
 * @param symbolCode the code of the symbol to handle
 * @returns the code of the symbol to handle 
 */ 
int getSymbolCode(int symbolCode){

    return symbolCode;    
}

/**
 * Function that handles the printing of codes for floating-point numbers.
 * 
 * @param floatingPointNumberCode the code of the floating-point number to handle
 * @returns the code of the floating-point number to handle 
 */ 
int getFloatingPointNumberCode(int floatingPointNumberCode){

    return floatingPointNumberCode;
}

/**
 * Function that handles the printing of codes for integer numbers.
 * 
 * @param integerNumberCode the code of the integer number to handle
 * @returns the code of the integer number to handle 
 */ 
int getIntegerNumberCode(int integerNumberCode){

    return integerNumberCode;
}

/**
 * Function that handles the printing of codes for identifiers.
 * 
 * @param identifierCode the code of the identifier to handle
 * @returns the code of the identifier to handle 
 */ 
int getIdentifier(int identifierCode){

    return identifierCode;
}

/**
 * Function for handling errors, i.e. tokens that are not recognized.
 */ 
void handleError(){

    //Just print the token
    printf("%s", yytext);
}

/**
 * Function to handle non-printable tokens.
 * 
 * @param code the token code
 */ 
void handleNonPrintableTokens(int code){

    printf("%s", yytext);
}

/**
 * Function to handle printable tokens
 * 
 * @param code the token code
 */ 
void handlePrintableTokens(int code){

    // Compute the token's category.
    int tokenCategory = code/TOKEN_CATEGORY_SIZE;

    // Switch between the possible token categories.
    switch(tokenCategory){

        case 0:
            printf("%d", getReservedWordCode(code));
            break;

        case 1:
            printf(" %d", getSymbolCode(code));
            break;

        case 2:
            printf("%d", getFloatingPointNumberCode(code));
            break;

        case 3:
            printf("%d", getIntegerNumberCode(code));
            break;

        case 4:
            printf("%d", getIdentifier(code));
            break;

        case 11:
            handleError();
    }
}

/**
 * Function that determines whether a token is a
 * printable character.
 * 
 * @param code the token code
 * @returns a positive number if the token is a 
 * printable character. Else, zero.
 */ 
int isPrintableCharacter(int code){

    return code >= 0;
}

// ################# SYNTAX ANALIZER #################

// Global variable to store the code of each token to be read.
int global_token_code = -1;

void printErrorMessage(char* errorMesssage){

    printf("Error! %s\n", errorMesssage);
    printf("no\n");
}

void skipSpaces(){

    do{
        global_token_code = yylex();
    } while(global_token_code == SYMBOL_SPACE);
}

void instr(){

    
}

void stmt_lst(){

    skipSpaces();

    // If after a few recursive loops we finish the list of statements (stmt_lst),
    // it's time to stop the recursion to close the optional statements (opt_stmts) 
    // section.
    if(global_token_code == SYMBOL_RT_BRACKET)
        return;

    instr();
    stmt_lst();
}

void opt_stmts(){

    skipSpaces();

    // Left bracket
    if(global_token_code == SYMBOL_LT_BRACKET){

        stmt_lst();

        // If we saw a left bracket, there must be a right bracket afterwards.
        if(global_token_code == SYMBOL_RT_BRACKET){

            printf("sí.\n");
        }   
        else{ 

            printErrorMessage("Expected a right bracket.");
        }
    }
    else{

        instr();
    }
}

void prog(){

    // Read the next token
    global_token_code = yylex();

    if (global_token_code == RES_WORD_PROGRAM) {

        skipSpaces();

        if (global_token_code == IDENTIFIER) {

            opt_stmts();
        }
        else{

            printErrorMessage("Expected an identifier.");
        }
    }
    else{

        printErrorMessage("Expected the token 'program'.");
    }
}

/**
 * Main function of the program.
 */ 
int main(){

    prog();

    // // Variable to store the code of each token to be read.
    // int code = -1;
    
    // while(1){
        
    //     code = yylex();

    //     // If this is the end of the file, stop here.
    //     if(code == END_OF_FILE)
    //         break;

    //     switch(isPrintableCharacter(code)){

    //         case 0:
    //             handleNonPrintableTokens(code);
    //             break;

    //         case 1:
    //             handlePrintableTokens(code);
    //             break;
    //     }
    // }

    // printf("\n");

    return 0;
}