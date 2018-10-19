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
#define SYMBOL_SPACE            -118
#define NEW_LINE                -119

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

"\n"                                                     { return NEW_LINE; }

.                                                       { return 1100; } /* Anything else */
%%

// ################# DATA STRUCTURES #################

struct node{

    int data;
    struct node* next;
};

struct node* global_stack_head = NULL;

void push(int data){

    struct node* tmp = (struct node*) malloc(sizeof(struct node));

    if(tmp == NULL) {

        printf("Error while requesting memory for a new node!\n");
        exit(0);
    }

    tmp->data = data;
    tmp->next = global_stack_head;
    global_stack_head = tmp;
}

void pop(){

    struct node* tmp = global_stack_head;
    global_stack_head = global_stack_head->next;
    free(tmp);
} 

int top(){

    return global_stack_head->data;
}  

void printStack(){

    struct node* current;
    current = global_stack_head;

    if(current != NULL){

        do{

            printf("%d ", current->data);
            current = current->next;

        }while(current != NULL);

        printf("\n");
    }
    else{

        printf("The stack is empty.\n");
    }
}

// Symbols for the stack
// Non-terminals
#define SYMBOL_DOLLAR_SIGN                      1000
#define NON_TERMINAL_PROG                       1001
#define NON_TERMINAL_OPT_STMTS                  1002
#define NON_TERMINAL_STMT                       1003
#define NON_TERMINAL_EXPRESION                  1004
#define NON_TERMINAL_STMT_LST                   1005
#define NON_TERMINAL_INSTR                      1006
#define NON_TERMINAL_EXPR                       1007
#define NON_TERMINAL_TERM                       1008
#define NON_TERMINAL_EXPR_                      1009
#define NON_TERMINAL_FACTOR                     1010
#define NON_TERMINAL_TERM_                      1011
#define NON_TERMINAL_EXPRESION_                 1012

// Terminals (those are defined as reserved words or symbols)

// ################# LEXICAL ANALIZER #################

// Error codes

#define ERR_CODE_RT_PARENTHESES                                 0
#define ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER               1
#define ERR_CODE_IDENTIFIER                                     2
#define ERR_CODE_SET_IF_IFELSE_WHILE                            3
#define ERR_CODE_SEMI_COLON                                     4
#define ERR_CODE_RT_BRACKET                                     5
#define ERR_CODE_PROGRAM                                        6
#define ERR_CODE_LT_PARENTHESES                                 7
#define ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON_LT_BRACKET       8
#define ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON                  9

// Error messages
#define ERR_MESSAGE_IDENTIFIER                          "Expected an identifier."
#define ERR_MESSAGE_PROGRAM                             "Expected the token 'program'."
#define ERR_MESSAGE_SET_IF_IFELSE_WHILE_SEMI_COLON      "Expected the token 'set', 'if', 'ifelse', 'while' or ';'."
#define ERR_MESSAGE_LT_PARENTHESES                      "Expected a left parentheses."
#define ERR_MESSAGE_SET_IF_IFELSE_WHILE                 "Expected the token 'set', 'if', 'ifelse' or 'while'."
#define ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER    "Expected a left parentheses, an identifier or a number."

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

// ################# SYNTAX ANALYZER #################

// Global variable to store the code of each token to be read.
int global_curr_token_code = -1;
int global_curr_parsed_line = 1;

void terminateProgram(int exitCode){

    exit(exitCode);
}

void printErrorMessage(int errorCode, char* currFunction, char* errorMesssage){

    printf("Error #%d at input line %d, function '%s': %s\n", errorCode, global_curr_parsed_line, currFunction, errorMesssage);
    printf("no\n");
    terminateProgram(1);
}

void printLastToken(char *readAtFunctionName){

    printf("Read at function '%s'; currToken = '%s'; at line = %d; global_curr_token_code = %d\n", readAtFunctionName, yytext, global_curr_parsed_line, global_curr_token_code);
}

int isPrintableToken(int tokenCode){

    return tokenCode >= 0;
}

/**
 * Function that reads the next token while skipping spaces.
 */ 
void readNextToken(){

    do{
        if(isPrintableToken(global_curr_token_code))
            printf("1 token = %s\n", yytext);

        global_curr_token_code = yylex();

        if(isPrintableToken(global_curr_token_code))
            printf("2 token = %s\n", yytext);

        if(global_curr_token_code == NEW_LINE)
            global_curr_parsed_line++;
        
    } while(!isPrintableToken(global_curr_token_code));

    // printLastToken("");
}

void tryToGoForwardInTheParsing(){

    while(top() == global_curr_token_code){

        pop();
        readNextToken();
    }
}

// void expr();
// void term();
// void stmt_lst();
// void opt_stmts();
// void instr(void caller());

// void factor(){

//     readNextToken();
//     printLastToken("factor");

//     if(global_curr_token_code == SYMBOL_LT_PARENTHESES){

//         expr();
//         readNextToken();

//         // If we saw a left parentheses, we should see a right parentheses afterwards.
//         if(global_curr_token_code != SYMBOL_RT_PARENTHESES){

//             printErrorMessage(ERR_CODE_RT_PARENTHESES, "factor", "Expected a right parentheses.");
//         }
//     } 
//     // If we didn't see a left parentheses, we should've seen an identifier, 
//     // an integer number or a right parentheses.
//     else if(global_curr_token_code == IDENTIFIER || global_curr_token_code == INTEGER_NUMBER){

//         readNextToken();
        
//         if(global_curr_token_code == SYMBOL_RT_PARENTHESES){
            
//             return;
//         }

//         // return;
//     }
//     else{

//         printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "factor", "Expected a left parentheses, an identifier or a number.");
//     }
// }

// void term_(){

//     factor();
//     term_();
// }

// void expr_(){

//     if(global_curr_token_code == SYMBOL_PLUS || global_curr_token_code == SYMBOL_MINUS){

//         term();
//         expr_();
//     }
// }

// void term(){

//     factor();
//     readNextToken();

//     if(global_curr_token_code == SYMBOL_STAR || global_curr_token_code == SYMBOL_FORWARD_SLASH){

//         term_();
//     }
//     else if(global_curr_token_code == SYMBOL_SEMI_COLON){

//         return;
//     }
// }

// void expr(){

//     term();

//     if(global_curr_token_code == SYMBOL_SEMI_COLON){

//         return;
//     }
//     // For parsing expressions inside statements
//     else if(global_curr_token_code == SYMBOL_LT 
//         || global_curr_token_code == SYMBOL_EQ
//         || global_curr_token_code == SYMBOL_GT
//         || global_curr_token_code == SYMBOL_RT_PARENTHESES){

//         return;
//     }
//     else{

//         expr_();
//     }
// }

// void expression(){

//     expr();
//     expr();
// }

void expr();

void factor(){

    // Pop the 'factor' symbol.
    pop();

    switch(global_curr_token_code){

        case IDENTIFIER:

            // Apply the 'factor -> id' rule.
            push(IDENTIFIER);

            // Pop the identifier
            pop();

            // Go forward in the input.
            readNextToken();

            break;

        case SYMBOL_LT_PARENTHESES:

            // Apply the 'factor -> (expr)' rule.
            push(SYMBOL_RT_PARENTHESES); 
            push(NON_TERMINAL_EXPR);
            push(SYMBOL_LT_PARENTHESES);

            // Pop the left parentheses
            pop();  

            // Go forward in the input.
            readNextToken();

            expr();      

            break;

        case INTEGER_NUMBER:

            // Apply the 'factor -> num' rule.
            push(INTEGER_NUMBER);

            // Pop the integer number
            pop();

            // Go forward in the input.
            readNextToken();

            break;
    }
}

void term(){

    // Pop the 'term' symbol.
    pop();

    switch(global_curr_token_code){

        case IDENTIFIER:
        case SYMBOL_LT_PARENTHESES:
        case INTEGER_NUMBER:

            // Apply the 'term -> factor term_' rule.

            push(NON_TERMINAL_TERM_);
            push(NON_TERMINAL_FACTOR);

            factor();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "term()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

void expresion(){

    // Pop the 'expresion' symbol.
    pop();

    switch(global_curr_token_code){

        case IDENTIFIER:
        case SYMBOL_LT_PARENTHESES:
        case INTEGER_NUMBER:
            
            // Apply the 'expresion -> expr expresion_' rule.

            push(NON_TERMINAL_EXPRESION_);
            push(NON_TERMINAL_EXPR);

            expr();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "expresion()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

void expr(){

    // Pop the 'expr' symbol.
    pop();

    switch(global_curr_token_code){

        case IDENTIFIER:
        case SYMBOL_LT_PARENTHESES:
        case INTEGER_NUMBER:
            
            // Apply the 'expr -> term expr_' rule.

            push(NON_TERMINAL_EXPR_);
            push(NON_TERMINAL_TERM);

            term();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "expr()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

void stmt(){

    // Pop the 'stmt' symbol
    pop();

    switch(global_curr_token_code){

        case RES_WORD_SET:
            
            // Apply the rule 'stmt -> set id expr'.
            push(NON_TERMINAL_EXPR);
            push(IDENTIFIER);
            push(RES_WORD_SET);

            // Pop the 'set' token.
            pop();

            // Go forward in the input.
            readNextToken();

            if(global_curr_token_code == IDENTIFIER){
                
                // Pop the identifier.
                pop();

                // Go forward in the input.
                readNextToken();

                expr();
            }
            else{

                printErrorMessage(ERR_CODE_IDENTIFIER, "stmt()", ERR_MESSAGE_IDENTIFIER);
            }

            break;

        case RES_WORD_IF:

            // Apply the rule 'stmt -> if (expresion) opt_stmts'.

            push(NON_TERMINAL_OPT_STMTS);
            push(SYMBOL_RT_PARENTHESES);
            push(NON_TERMINAL_EXPRESION);
            push(SYMBOL_LT_PARENTHESES);
            push(RES_WORD_IF);

            // Pop the 'if' token.
            pop();

            // Go forward in the input.
            readNextToken();

            if(global_curr_token_code == SYMBOL_LT_PARENTHESES){
                
                // Pop the left parentheses.
                pop();  

                // Go forward in the input.
                readNextToken();

                expresion();
            }
            else{

                printErrorMessage(ERR_CODE_LT_PARENTHESES, "stmt()", ERR_MESSAGE_LT_PARENTHESES);
            }

            break;

        case RES_WORD_IFELSE:

            // Apply the rule 'stmt -> ifelse (expresion) opt_stmts opt_stmts'

            push(NON_TERMINAL_OPT_STMTS);
            push(NON_TERMINAL_OPT_STMTS);
            push(SYMBOL_RT_PARENTHESES);
            push(NON_TERMINAL_EXPRESION);
            push(SYMBOL_LT_PARENTHESES);
            push(RES_WORD_IFELSE);

            // Pop the 'ifelse' token
            pop();

            // Go forward in the input
            readNextToken();

            if(global_curr_token_code == SYMBOL_LT_PARENTHESES){
                
                // Pop the left parentheses
                pop();  

                // Go forward in the input
                readNextToken();

                expresion();
            }
            else{

                printErrorMessage(ERR_CODE_LT_PARENTHESES, "stmt", ERR_MESSAGE_LT_PARENTHESES);
            }

            break;

        case RES_WORD_WHILE:

            // Apply the rule 'stmt -> while (expresion) opt_stmts'.

            push(NON_TERMINAL_OPT_STMTS);
            push(SYMBOL_RT_PARENTHESES);
            push(NON_TERMINAL_EXPRESION);
            push(SYMBOL_LT_PARENTHESES);
            push(RES_WORD_WHILE);

            // Pop the 'while' token.
            pop();

            // Go forward in the input.
            readNextToken();

            if(global_curr_token_code == SYMBOL_LT_PARENTHESES){
                
                // Pop the left parentheses.
                pop();  

                // Go forward in the input.
                readNextToken();

                expresion();
            }
            else{

                printErrorMessage(ERR_CODE_LT_PARENTHESES, "stmt()", ERR_MESSAGE_LT_PARENTHESES);
            }

            break;
    
        default:

            printErrorMessage(ERR_CODE_SET_IF_IFELSE_WHILE, "stmt()", ERR_MESSAGE_SET_IF_IFELSE_WHILE);   
    }
}

void instr(){

    // Pop the 'instr' symbol.
    pop();

    switch(global_curr_token_code){

        case RES_WORD_SET:
        case RES_WORD_IF:
        case RES_WORD_IFELSE:
        case RES_WORD_WHILE:

            push(NON_TERMINAL_STMT);
            stmt();
            break;

        case SYMBOL_SEMI_COLON:

            // Do nothing.
            break;

        default:
            printErrorMessage(ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON, "instr()", ERR_MESSAGE_SET_IF_IFELSE_WHILE_SEMI_COLON);
    }
}

void stmt_lst(){

    // Pop the 'stmt_lst' symbol.
    pop();

    switch(global_curr_token_code){

        case RES_WORD_SET:
        case RES_WORD_IF:
        case RES_WORD_IFELSE:
        case RES_WORD_WHILE:
        case SYMBOL_SEMI_COLON:

            // Apply the rule 'stmt_lst -> instr stmt_lst'.
            push(NON_TERMINAL_STMT_LST);
            push(NON_TERMINAL_INSTR);

            instr();
            break;
        
        case SYMBOL_RT_BRACKET:

            // This corresponds to the rule stmt_lst -> epsilon.
            // Do nothing.

            break;
    }
}

void opt_stmts(){

    readNextToken();

    // Pop the 'opt_stmts' symbol.
    pop();

    switch(global_curr_token_code){

        case RES_WORD_SET:
        case RES_WORD_IF:
        case RES_WORD_IFELSE:
        case RES_WORD_WHILE:
        case SYMBOL_SEMI_COLON:

            push(NON_TERMINAL_INSTR);
            instr();
            break;

        case SYMBOL_LT_BRACKET:

            push(SYMBOL_RT_BRACKET);
            push(NON_TERMINAL_STMT_LST);
            push(SYMBOL_LT_BRACKET);

            // Consume the left bracket.
            pop();
            readNextToken();

            // Go to stmt_lst.
            stmt_lst();
            break;

        default:
            printErrorMessage(ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON_LT_BRACKET, "opt_stmts()", "Expected the token 'set', 'if', 'ifelse', 'while', ';' or '{'.");
    }
}

void prog(){

    // Read the next token.
    readNextToken();

    // If the rule applies.
    if(top() == NON_TERMINAL_PROG && global_curr_token_code == RES_WORD_PROGRAM){

        // Change the current stack top for the right side of the rule.
        // Push the right side of the rule to the stack in reverse order.
        // prog -> program id opt_stmts
        
        pop();
        push(NON_TERMINAL_OPT_STMTS);
        push(IDENTIFIER);

        // Push and pop or do nothing
        // push(RES_WORD_PROGRAM);
        // pop();

        readNextToken();

        if(top() == IDENTIFIER && global_curr_token_code == IDENTIFIER){

            // Pop the identifier.
            pop();

            // Go to opt_stmts.
            opt_stmts();
        }
        else{

            printErrorMessage(ERR_CODE_IDENTIFIER, "prog()", ERR_MESSAGE_IDENTIFIER);
        }
    }
    else{

        printErrorMessage(ERR_CODE_PROGRAM, "prog()", ERR_MESSAGE_PROGRAM);
    }
}

void handleInput(int argc, char **argv){

    if(argc > 1){

        // Open the input file.
        yyin = fopen(argv[1], "r");
    }
    else{

        yyin = stdin;
    }
}

/**
 * Main function of the program.
 */ 
int main(int argc, char **argv){

    /**
     * Pseudocode:
     * 
     * While the stack is not empty, compare the top of the stack 
     * and the last read token.
     * 
     * Case 1: they're equal
     *      - pop that element from the stack
     *      - read the next input token
     * 
     * Case 2: there is a rule that links them
     *      - Swap the stack top for the right side of the rule. 
     *        Push that rule right side in reverse order to match
     *        the stack's FIFO behavior.
     * 
     * If the input is finished and the stack
     * Exit states:
     * 
     * 1. Consumed input and stack with the $ (dollar sign) at the top: success via empty stack.
     * 2. If the parser cannot perform a valid transition, the input is rejected.
     */ 

    handleInput(argc, argv);

    // Push the end-of-input symbol to the stack
    push(SYMBOL_DOLLAR_SIGN);
    
    // Push the initial grammar symbol "prog" to the stack
    push(NON_TERMINAL_PROG);
    
    // Call the initial function
    prog();
    printf("sí.\n");

    return 0;
}