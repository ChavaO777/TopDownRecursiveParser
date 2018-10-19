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

/**
 * Definition of a node for the linked-list 
 * to be used as a stack
 */
struct node{

    int data;
    struct node* next;
};

// Global variable corresponding to the pointer to the head of the 
// linked list used as a stack.
struct node* global_stack_head = NULL;

/**
 * Function for pushing a new element to the stack.
 * 
 * @param data an integer corresponding to the data of the new
 * member of the stack.
 */ 
void push(int data){

    // Ask for memory for the new node
    struct node* tmp = (struct node*) malloc(sizeof(struct node));

    // If the memory was not given
    if(tmp == NULL) {

        printf("Error while requesting memory for a new node!\n");
        exit(0);
    }

    // Assign the data
    tmp->data = data;
    
    // Assign the next node of the new node
    tmp->next = global_stack_head;

    // Assign the head to the new node
    global_stack_head = tmp;
}

/**
 * Function for popping from the stack
 */ 
void pop(){

    // Get a pointer to the current head.
    struct node* tmp = global_stack_head;
    
    // Move the head to the next node of the current head.
    global_stack_head = global_stack_head->next;

    // Free the node corresponding to the old head.
    free(tmp);
} 

/**
 * Function that retrieves the data of the top node 
 * in the stack.
 * 
 * @returns the data of the top node in the stack.
 */ 
int top(){

    return global_stack_head->data;
}  

/**
 * Function that prints the stack
 */ 
void printStack(){

    // Get a pointer to the current head.
    struct node* current = global_stack_head;


    if(current != NULL){
        
        // Traverse the linked list
        do{

            printf("%d ", current->data);

            // Move to the next node
            current = current->next;

        }while(current != NULL);

        printf("\n");
    }
    else{
        
        // Let the user know that the stack is empty.
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

#define ERR_CODE_RT_PARENTHESES                                         0
#define ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER                       1
#define ERR_CODE_IDENTIFIER                                             2
#define ERR_CODE_SET_IF_IFELSE_WHILE                                    3
#define ERR_CODE_SEMI_COLON                                             4
#define ERR_CODE_RT_BRACKET                                             5
#define ERR_CODE_PROGRAM                                                6
#define ERR_CODE_LT_PARENTHESES                                         7
#define ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON_LT_BRACKET               8
#define ERR_CODE_SET_IF_IFELSE_WHILE_SEMICOLON                          9
#define ERR_CODE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS           10
#define ERR_CODE_LT_GT_EQ                                               11

// Error messages
#define ERR_MESSAGE_IDENTIFIER                                          "Expected an identifier."
#define ERR_MESSAGE_PROGRAM                                             "Expected the token 'program'."
#define ERR_MESSAGE_SET_IF_IFELSE_WHILE_SEMI_COLON                      "Expected the token 'set', 'if', 'ifelse', 'while' or ';'."
#define ERR_MESSAGE_LT_PARENTHESES                                      "Expected a left parentheses."
#define ERR_MESSAGE_SET_IF_IFELSE_WHILE                                 "Expected the token 'set', 'if', 'ifelse' or 'while'."
#define ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER                    "Expected a '(', an identifier or a number."
#define ERR_MESSAGE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS        "Expected a ')', ';', '<', '>', '=', '+' or '-' token."
#define ERR_MESSAGE_LT_GT_EQ                                            "Expected a '<', '>' or '=' token."

// ################# SYNTAX ANALYZER #################

// Global variable to store the code of each token to be read.
int global_curr_token_code = -1;
int global_curr_parsed_line = 1;

/**
 * Function that terminates the program.
 * 
 * @param exitCode the exit code to terminate this program with.
 */ 
void terminateProgram(int exitCode){

    exit(exitCode);
}

/**
 * Function that prints an error message and calls the termination of the program.
 * 
 * @param errorCode The error code associated to this error.
 * @param currFunction The name of the function in which the error occurred.
 * @param errorMesssage A message to the user.
 */ 
void printErrorMessage(int errorCode, char* currFunction, char* errorMesssage){

    printf("Error #%d at input line %d, function '%s': %s\n", errorCode, global_curr_parsed_line, currFunction, errorMesssage);
    printf("no\n");
    terminateProgram(1);
}

/**
 * Function that prints the last read token.
 * 
 * @param readAtFunctionName the name of the function in which this token was read.
 */ 
void printLastToken(char *readAtFunctionName){

    printf("Read at function '%s'; currToken = '%s'; at line = %d; global_curr_token_code = %d\n", readAtFunctionName, yytext, global_curr_parsed_line, global_curr_token_code);
}

/**
 * Function that determines whether a token is a
 * printable character.
 * 
 * @param tokenCode the token code
 * @returns a positive number if the token is a 
 * printable character. Else, zero.
 */ 
int isPrintableToken(int tokenCode){

    return tokenCode >= 0;
}

/**
 * Function that reads the next token while skipping spaces.
 */ 
void readNextToken(){

    do{
        // if(isPrintableToken(global_curr_token_code))
        //     printf("1 token = %s\n", yytext);

        global_curr_token_code = yylex();

        // if(isPrintableToken(global_curr_token_code))
        //     printf("2 token = %s\n", yytext);

        if(global_curr_token_code == NEW_LINE)
            global_curr_parsed_line++;
        
    } while(!isPrintableToken(global_curr_token_code));
}

void expr();
void term();
void factor();

/**
 * Function for the 'term_' grammar symbol
 */ 
void term_(){

    // Pop the 'term_' symbol.
    pop();

    switch(global_curr_token_code){

        case SYMBOL_RT_PARENTHESES:
        case SYMBOL_SEMI_COLON:
        case SYMBOL_LT:
        case SYMBOL_GT:
        case SYMBOL_EQ:
        case SYMBOL_PLUS:
        case SYMBOL_MINUS:

            // Apply the rule 'term_ -> epsilon'.
            // Do nothing.

            break;

        case SYMBOL_STAR:

            // Apply the rule 'term_ -> * factor term_'.

            push(NON_TERMINAL_TERM_);
            push(NON_TERMINAL_FACTOR);
            push(SYMBOL_STAR);

            // Pop the '*' token.
            pop();

            // Go forward in the input.
            readNextToken();

            factor();
            term_();

            break;

        case SYMBOL_FORWARD_SLASH:

            // Apply the rule 'term_ -> / factor term_'.

            push(NON_TERMINAL_TERM_);
            push(NON_TERMINAL_FACTOR);
            push(SYMBOL_FORWARD_SLASH);

            // Pop the '/' token.
            pop();

            // Go forward in the input.
            readNextToken();

            factor();
            term_();

            break;

        default:

            printErrorMessage(ERR_CODE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS, "term_()", ERR_MESSAGE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS);
    }
}

/**
 * Function for the 'expresion_' grammar symbol
 */ 
void expresion_(){

    // Pop the 'expresion_' symbol.
    pop();

    switch(global_curr_token_code){

        case SYMBOL_LT:

            // Apply the rule 'expresion_ -> < expr'.
            push(NON_TERMINAL_EXPR);
            push(SYMBOL_LT);

            // Pop the '<' token.
            pop();

            // Go forward in the input.
            readNextToken();

            expr();

            break;

        case SYMBOL_GT:

            // Apply the rule 'expresion_ -> > expr'.
            push(NON_TERMINAL_EXPR);
            push(SYMBOL_GT);

            // Pop the '>' token.
            pop();

            // Go forward in the input.
            readNextToken();

            expr();

            break;

        case SYMBOL_EQ:

            // Apply the rule 'expresion_ -> = expr'.
            push(NON_TERMINAL_EXPR);
            push(SYMBOL_EQ);

            // Pop the '=' token.
            pop();

            // Go forward in the input.
            readNextToken();

            expr();
            break;

        default:

            printErrorMessage(ERR_CODE_LT_GT_EQ, "expresion_()", ERR_MESSAGE_LT_GT_EQ);
    }
}

/**
 * Function for the 'expr_' grammar symbol
 */ 
void expr_(){

    // Pop the 'expr_' symbol.
    pop();

    switch(global_curr_token_code){

        case SYMBOL_RT_PARENTHESES:
        case SYMBOL_SEMI_COLON:
        case SYMBOL_LT:
        case SYMBOL_GT:
        case SYMBOL_EQ:

            // Apply the rule 'expr_ -> epsilon'.
            // Do nothing.

            break;
        
        case SYMBOL_PLUS:

            // Apply the 'expr_ -> + term expr_' rule.

            push(NON_TERMINAL_EXPR_);
            push(NON_TERMINAL_TERM);
            push(SYMBOL_PLUS);
            
            // Pop the plus symbol
            pop();
            
            // Go forward in the input.
            readNextToken();

            term();
            expr_();

            break;

        case SYMBOL_MINUS:

            // Apply the 'expr_ -> - term expr_' rule.

            push(NON_TERMINAL_EXPR_);
            push(NON_TERMINAL_TERM);
            push(SYMBOL_MINUS);
            
            // Pop the minus symbol
            pop();
            
            // Go forward in the input.
            readNextToken();

            term();
            expr_();

            break;

        default:

            printErrorMessage(ERR_CODE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS, "expr_()", ERR_MESSAGE_RT_PARENTHESES_SEMICOLON_LT_GT_EQ_PLUS_MINUS);
    }
}

/**
 * Function for the 'factor' grammar symbol
 */ 
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

/**
 * Function for the 'term' grammar symbol
 */ 
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
            term_();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "term()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

/**
 * Function for the 'expresion' grammar symbol
 */ 
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
            expresion_();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "expresion()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

/**
 * Function for the 'expr' grammar symbol
 */ 
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
            expr_();

            break;

        default:

            printErrorMessage(ERR_CODE_LT_PARENTHESES_IDENTIFIER_NUMBER, "expr()", ERR_MESSAGE_LT_PARENTHESES_IDENTIFIER_NUMBER);
    }
}

/**
 * Function for the 'stmt' grammar symbol
 */ 
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

/**
 * Function for the 'instr' grammar symbol
 */ 
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

/**
 * Function for the 'stmt_lst' grammar symbol
 */ 
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

/**
 * Function for the 'opt_stmts' grammar symbol
 */ 
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

/**
 * Entry function of the LL1 grammar corresponding to its first rule: 'prog'.
 */ 
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
        push(RES_WORD_PROGRAM);

        // Pop the 'program' reserved word
        pop();

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

/**
 * Function for handling input either from arguments to the main() function
 * or from standard input (e.g. redirection to file.)
 * 
 * @param argc the amount of arguments that the main() function received.
 * @param argv the pointer to pointer to char corresponding to the arguments 
 * that the main() function received.
 */ 
void handleInput(int argc, char **argv){

    // If an input file was passed
    if(argc > 1){

        // Open the input file.
        yyin = fopen(argv[1], "r");
    }
    else{
        
        // Else, just use standard input
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