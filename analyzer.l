%{
#include <stdio.h>
#include "analyzer.h"

void printAndIncrementOperatorCounts(char* yytext, char * type, int store[2]){
		printf("%s operator: %s\n\n", type, yytext);
		store[TOKEN_COUNT] = 1;
		store[LEXEME_COUNT] += 1;
	}

void printAndIncrementCounts(char* yytext, char * type, int store[2]){
		printf("%s: %s\n\n", type, yytext);
		store[TOKEN_COUNT] = 1;
		store[LEXEME_COUNT] += 1;
	}

%}

KEYWORDS (auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|then|typedef|union|unsigned|void|volatile|while)
QUOTED_STRING \".*\"
ARITHMETIC_OPERATORS (\+|-|\*|\/|%)
RELATIONAL_OPEARATORS (>|<|>=|<=|==|!=)
LOGICAL_OPERATORS (\|\||&&|!)
BITWISE_OPERATORS (&|\||<<|>>|~|\^)
RIGHT_PAREN \)
SEPARATOR ,
TERMINATOR ;
LEFT_CURLY_BRACKET \{
RIGHT_CURLY_BRACKET \}
LEFT_BRACKET \[
RIGHT_BRACKET \]
COMMENT (\/\*([^*]|\*+[^/])*\*+\/|\/\/.*)
TERNARY_QUESTION_MARK \?

%%
{QUOTED_STRING}  {
	printAndIncrementCounts(yytext, "string literal", literals);
}

{KEYWORDS} { printAndIncrementCounts(yytext, "keyword", keywords); }

[[:alpha:]_][[:alnum:]_]*  {
	printAndIncrementCounts(yytext, "identifier", identifiers);
}

[0-9]+ {
	printAndIncrementCounts(yytext, "integer", integers);
}

[0-9]+\.[0-9]+ {
	printAndIncrementCounts(yytext, "float", floats);
}

[+][+]|[-][-] printAndIncrementOperatorCounts(yytext, "unary", unary_operators);

{ARITHMETIC_OPERATORS}  {
	printAndIncrementOperatorCounts(yytext, "arithmetic", arithmetic_operators);
}

{RELATIONAL_OPEARATORS}  {
	printAndIncrementOperatorCounts(yytext, "relational", relational_operators);
}

[+=]|[-=]|[*=]|[/=]|[=]|[%=] printAndIncrementOperatorCounts(yytext, "assignment", assignment_operators);

{LOGICAL_OPERATORS}  {
	printAndIncrementOperatorCounts(yytext, "logical", logical_operators);
}

{BITWISE_OPERATORS}  {
	printAndIncrementOperatorCounts(yytext, "bitwise", bitwise_operators);
}

{TERNARY_QUESTION_MARK} {
	printAndIncrementCounts(yytext, "question mark", ternary_question_mark);
}

[:] {
	printAndIncrementCounts(yytext, "colon bracket", ternary_colon);
}

{TERMINATOR}  {
	printAndIncrementCounts(yytext, "terminator", terminator);
}

[(] printAndIncrementCounts(yytext, "left paren", left_paren);

{RIGHT_PAREN} {
	printAndIncrementCounts(yytext, "right paren", right_paren);
}

{LEFT_BRACKET} {
	printAndIncrementCounts(yytext, "left bracket", left_bracket);
}

{RIGHT_BRACKET} {
	printAndIncrementCounts(yytext, "right bracket", right_bracket);
}

{LEFT_CURLY_BRACKET} {
	printAndIncrementCounts(yytext, "left curly bracket", left_curly_bracket);
}

{RIGHT_CURLY_BRACKET} {
	printAndIncrementCounts(yytext, "right curly bracket", right_curly_bracket);
}

{COMMENT} {
	printf("Skipping comment: %s\n\n", yytext);
}

[[:punct:]] {
	printAndIncrementCounts(yytext, "punctuation", punctuation);
}

[([:blank:]|\n)]  {}

%%

int yywrap(void) {
	return 1;
}

int main(void){
	yyin = fopen("input.txt", "r");
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


