%{
#include <stdio.h>
int yylex();
int yyerror();
%}

%start start
%token PROG_BEGIN PROG_END MAIN IF ELSE WHILE CONSTANT RETURN PREDICATE PREDICATE_NAME INPUT OUTPUT TRUE FALSE UNKNOWN IDENTIFIER COMMENT INT STRING CHAR ASSIGN_OP EQUALITY_OP NEWLINE LP RP LCB RCB LSQB RSQB SEMICOLON OR_OP AND_OP NOT_OP CM EQUIVALENCE_OP IMPLIES_OP LETTER DOLAR
%%
start: program ;
program: PROG_BEGIN statements PROG_END {return 0;}
 | PROG_BEGIN main_declaration PROG_END ;
main_declaration: MAIN LP RP LCB statements RCB ;
statements: statements SEMICOLON statement | statement | statements SEMICOLON COMMENT;
statement: control_statement
 | loop_statement
 | regular_statement
 | predicate_definition
 | predicate_instantiation
 | empty ;
control_statement: with_else
  | without_else ;
with_else: IF LP proposition RP LCB with_else RCB ELSE LCB with_else RCB
 | LCB loop_statement RCB
 | LCB regular_statement RCB;
without_else: IF LP proposition RP LCB statements RCB
 | IF LP proposition RP LCB with_else RCB ELSE LCB without_else RCB ;
loop_statement: WHILE LP proposition RP LCB statements RCB ;
regular_statement: return_statement
  | assignment_operation
  | input
  | output ;
predicate_definition: PREDICATE predicate_name LP param_list RP LCB statements RCB ;
predicate_instantiation: DOLAR predicate_name LP param_list RP ;
predicate_name: PREDICATE_NAME INT
  | PREDICATE_NAME LETTER
  | LETTER ;
proposition: param_list exp param_list ;
return_statement: RETURN IDENTIFIER
  | RETURN truth_val ;
assignment_operation : IDENTIFIER ASSIGN_OP proposition
   	| IDENTIFIER ASSIGN_OP STRING
	| IDENTIFIER ASSIGN_OP CHAR
	| IDENTIFIER ASSIGN_OP INT
	| IDENTIFIER ASSIGN_OP IDENTIFIER
	| IDENTIFIER ASSIGN_OP truth_val
   | proposition ASSIGN_OP truth_val 
	| CONSTANT IDENTIFIER ASSIGN_OP INT
	| CONSTANT IDENTIFIER ASSIGN_OP truth_val ; 
input: INPUT LCB proposition RCB ;
output: OUTPUT LSQB proposition RSQB ;
param_list: param_list CM param_list
 | IDENTIFIER
 | INT
 | truth_val
 | empty ;
exp: IMPLIES_OP
	|OR_OP
	|AND_OP
	|NOT_OP
	|EQUIVALENCE_OP
	;

truth_val: TRUE
	| FALSE
	| UNKNOWN;
empty: ;
%%
#include "lex.yy.c"
extern int lineCount;
int yyerror(char *s) {
	printf("SYNTAX ERROR ON LINE %d!\n", lineCount);
}
int main() {
	if (yyparse() == 0)
		printf("Input program is valid.\n");
	return 0;
}

