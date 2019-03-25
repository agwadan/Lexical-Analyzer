%{
#include <stdio.h>
#include "analyzer.h"

void getTotalCountOperator(char* yytext, char * type, int store[2]){
		printf("%s operator: %s\n\n", type, yytext);
		store[TOKEN_COUNT] = 1;
		store[LEXEME_COUNT] += 1;
	}

void getTotal(char* yytext, char * type, int store[2]){
		printf("%s: %s\n\n", type, yytext);
		store[TOKEN_COUNT] = 1;
		store[LEXEME_COUNT] += 1;
	}

%}

KEYWORDS (auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|then|typedef|union|unsigned|void|volatile|while)
BITWISE_OPERATORS (&|\||<<|>>|~|\^)

%%
{KEYWORDS} { getTotal(yytext, "keyword", keywords); }

["].*["]  getTotal(yytext, "string literal", literals);

[[:alpha:]_][[:alnum:]_]*  {
	getTotal(yytext, "identifier", identifiers);
}

[0-9]+ {
	getTotal(yytext, "integer", integers);
}

[0-9]+\.[0-9]+  getTotal(yytext, "float", floats);

[+][+]|[-][-] getTotalCountOperator(yytext, "unary", unary_operators);

[+]|[-]|[*]|[/]|[%]  getTotalCountOperator(yytext, "arithmetic", arithmetic_operators);

[,] getTotal(yytext, "separator", separator);

[>]|[<]|[>=]|[<=]|[==]|[!=] getTotalCountOperator(yytext, "relational", relational_operators);

[+][=]|[-][=]|[*][=]|[/][=]|[=]|[%][=] getTotalCountOperator(yytext, "assignment", assignment_operators);

[||]|[&&]|[!]  getTotalCountOperator(yytext, "logical", logical_operators);

{BITWISE_OPERATORS} { getTotalCountOperator(yytext, "bitwise", bitwise_operators); }

[?]	getTotal(yytext, "question mark", ternary_question_mark);

[:] getTotal(yytext, "colon bracket", ternary_colon);

[;] getTotal(yytext, "terminator", terminator);

[(] getTotal(yytext, "left paren", left_paren);

[)]	getTotal(yytext, "right paren", right_paren);

[[]	getTotal(yytext, "left bracket", left_bracket);

[]]	getTotal(yytext, "right bracket", right_bracket);

[{]	getTotal(yytext, "left curly bracket", left_curly_bracket);

[}]	getTotal(yytext, "right curly bracket", right_curly_bracket);

[/][*].*[*][/]|[/][/].*  printf("Skipping comment: %s\n\n", yytext);

[[:punct:]]  getTotal(yytext, "punctuation", punctuation);

[ ] | \t | \n  ;

%%

int yywrap(void) {
	return 1;
}

int main(void){

	char filename[50];
	printf("Enter the source code filename(<filename>.c): \n\n");

	scanf("%s", filename);

	yyin = fopen(filename, "r");

	yylex();
	int token_count = literals[TOKEN_COUNT] +
										identifiers[TOKEN_COUNT] +
										keywords[TOKEN_COUNT] +
										integers[TOKEN_COUNT] +
										floats[TOKEN_COUNT] +
										punctuation[TOKEN_COUNT] +
										unary_operators[TOKEN_COUNT] +
										arithmetic_operators[TOKEN_COUNT] +
										relational_operators[TOKEN_COUNT] +
										assignment_operators[TOKEN_COUNT] +
										logical_operators[TOKEN_COUNT] +
										bitwise_operators[TOKEN_COUNT] +
										left_paren[TOKEN_COUNT] +
										right_paren[TOKEN_COUNT] +
										separator[TOKEN_COUNT] +
										terminator[TOKEN_COUNT] +
										left_curly_bracket[TOKEN_COUNT] +
										right_curly_bracket[TOKEN_COUNT] +
										left_bracket[TOKEN_COUNT] +
										right_bracket[TOKEN_COUNT] +
										ternary_question_mark[TOKEN_COUNT] +
										ternary_colon[TOKEN_COUNT];

int lexeme_count =  literals[LEXEME_COUNT] +
										identifiers[LEXEME_COUNT] +
										keywords[LEXEME_COUNT] +
										integers[LEXEME_COUNT] +
										floats[LEXEME_COUNT] +
										punctuation[LEXEME_COUNT] +
										unary_operators[LEXEME_COUNT] +
										arithmetic_operators[LEXEME_COUNT] +
										relational_operators[LEXEME_COUNT] +
										assignment_operators[LEXEME_COUNT] +
										logical_operators[LEXEME_COUNT] +
										bitwise_operators[LEXEME_COUNT] +
										left_paren[LEXEME_COUNT] +
										right_paren[LEXEME_COUNT] +
										separator[LEXEME_COUNT] +
										terminator[LEXEME_COUNT] +
										left_curly_bracket[LEXEME_COUNT] +
										right_curly_bracket[LEXEME_COUNT] +
										left_bracket[LEXEME_COUNT] +
										right_bracket[LEXEME_COUNT] +
										ternary_question_mark[LEXEME_COUNT] +
										ternary_colon[LEXEME_COUNT];

	printf("Token count: %d\nLexeme Count: %d\n", token_count, lexeme_count);

	return 0;
}


