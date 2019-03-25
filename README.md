# LEXICAL ANALYZER

## Introduction

This is a lexical analyzer that identifies tokens i.e. integer numbers, decimal numbers, identifiers, keywords, aithmetic operators and relational operators. 

We developed this using the LEX tool and C programming language..

## Details of the program

There are four prgrams 

## Scanner.h

This is the header file that contains all the definitions in used in the lexical analyzer. 

## Scanner.l

This is the lex file that contains three parts.

The first part contains global "C" code used by the lex file written as ``` %{...%}``` where all the declarations appear within the brackets.

The second part contains the regular expression patterns and the actions performed when a pattern is recognised. The code for this part appears between a pair of double "%" symbols i.e. ```%%...%%"``` .

The third part like the first part contans "C" code.

## Scanner.c



