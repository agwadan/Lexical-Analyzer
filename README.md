# LEXICAL ANALYZER

## Introduction

This is a lexical analyzer that identifies tokens i.e. integer numbers, decimal numbers, identifiers, keywords, aithmetic operators and relational operators. 

We developed this using the LEX tool and C programming language..

## Details of the program

The program has two main components... analyzer.h and analyzer.l
It also has two more files that are automatically generated during compilation i.e lex.yy.c and a.out

## analyzer.h

This is the header file that contains all the definitions being used in by the lexical analyzer. 

## analyzer.l

This is the lex file that contains three main parts.

The first part contains global "C" code used by the lex file written as ``` %{...%}``` where all the declarations appear within the brackets. NOTE: It is also here that we import the efinitions in out (analyzer.h) file.

The second part contains the regular expression patterns and the actions performed when a pattern is recognised. The code for this part appears between a pair of double "%" symbols i.e. ```%%...%%"``` .

The third part like the first, contans "C" code.

## Installation

To run this, you need a flex tool installed on your computer. To do this in a linux based system, use the following commands.

```sudo apt-get update```

```sudo apt-get install bison```

```sudo apt-get install flex```

The next step is to clone or download the code and access the directory using terminal. Compiile the lex file using the command ```lex analyzer.l``` , followed by ```gcc analyzer.c lex.yy.c -o analyzer```.

## How to Run the Analyzer

markup: 1. lex analyzer.l .... this compiles the lex file and automatically generates the lex.yy.c file
markup: 2. cc lex.yy.c .... this compiles our generated "C" source file
markup: 3. ./a.out .... this runs the executable and gives the output 

### OUTPUT
The program will ask for the user to enter a name of a source file which should be lexically analized
(Here, we have used an example file .... "input.txt")

Then the lexical analizer will run, and print the number of TOKENS and LEXEMES in the file.
