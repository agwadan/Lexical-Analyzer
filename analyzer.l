%{
#include "sds/sds.c"
#include <stdio.h>
#include "analyzer.h"

sds identifier_names;
sds integer_names;
sds float_names;

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
{KEYWORDS} { getTotal(yytext, "KEYWORD", keywords); }

["].*["]  getTotal(yytext, "STRING LITERAL", literals);

[[:alpha:]_][[:alnum:]_]*  {
	getTotal(yytext, "IDENTIFIER", identifiers);
	identifier_names = sdscat(identifier_names, yytext);
	identifier_names = sdscat(identifier_names, ",");
}

[0-9]+ {
	getTotal(yytext, "INTEGER", integers);
}

[0-9]+\.[0-9]+  getTotal(yytext, "FLOAT", floats);

[+][+]|[-][-] getTotalCountOperator(yytext, "UNARY", unary_operators);

[+]|[-]|[*]|[/]|[%]  getTotalCountOperator(yytext, "ARITHMETIC", arithmetic_operators);

[,] getTotal(yytext, "SEPARATOR", separator);

[>]|[<]|[>=]|[<=]|[==]|[!=] getTotalCountOperator(yytext, "RELATIONAL", relational_operators);

[+][=]|[-][=]|[*][=]|[/][=]|[=]|[%][=] getTotalCountOperator(yytext, "ASSIGNMENT", assignment_operators);

[||]|[&&]|[!]  getTotalCountOperator(yytext, "LOGICAL", logical_operators);

{BITWISE_OPERATORS} { getTotalCountOperator(yytext, "BITWISE", bitwise_operators); }

[?]	getTotal(yytext, "QUESTION MARK", ternary_question_mark);

[:] getTotal(yytext, "COLON BRACKET", ternary_colon);

[;] getTotal(yytext, "TERMINATOR", terminator);

[(] getTotal(yytext, "LEFT PARENTHESIS", left_paren);

[)]	getTotal(yytext, "RIGHT PARENTHESIS", right_paren);

[[]	getTotal(yytext, "LEFT BRACKET", left_bracket);

[]]	getTotal(yytext, "RIGHT BRACKET", right_bracket);

[{]	getTotal(yytext, "LEFT CURLY BRACKET", left_curly_bracket);

[}]	getTotal(yytext, "RIGHT CURLY BRACKET", right_curly_bracket);

[/][*].*[*][/]|[/][/].*  printf("Comment skipped: %s\n\n", yytext);

[[:punct:]]  getTotal(yytext, "PUNCTUATION", punctuation);

[ ] | \t | \n  ;

%%

int yywrap(void) {
	return 1;
}

int main(void){

	char inputFile[20];
	identifier_names = sdsempty();
	float_names = sdsempty();
	integer_names = sdsempty();
	
	printf("Enter the source code inputFile(<inputFile>.c): \n\n");

	scanf("%s", inputFile);

	yyin = fopen(inputFile, "r");

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

	/* split string */
	int identifierLength = (int) sdslen(identifier_names);
	int identifierCount = 0;

	/* split string */
	sds* listIdentifiers = sdssplitlen(identifier_names, identifierLength, ",", 1, &identifierCount);

	printf("\nSymbol Table:\n\n");
	printf("%-20s%-20s%-20s\n", "Symbol", "Type", "Value");

	for(int i = 0; i<identifierCount; i++){
		printf("%-20s\n", listIdentifiers[i]);
	}

	return 0;
}


