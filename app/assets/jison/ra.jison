
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
\'([^\n'\"?\\]|\\[nt'\"?\\])+\' return 'STRING'
[0-9]+("."[0-9]+)?              return 'NUMBER'
("sigma")|"σ"                   return 'SELECT'
("pi")|"π"                      return 'PROJECT'
("join")|"⋈"                   return 'JOIN'
("and")|"∧"                     return 'AND'
("or")|"∨"                      return 'OR'
("not")|"¬"                     return 'NOT'
"("                             return '('
")"                             return ')'
"=="                            return '=='
"!="                            return '!='
"<"                             return '<'
">"                             return '>'
"<="                            return '<='
">="                            return '>='
"."                             return '.'
","                             return ','
[a-zA-Z_]+                      return 'ID'
<<EOF>>                         return 'EOF'
.                               return 'INVALID'

/lex

/* operator associations and precedence */
%left  JOIN
%left  OR
%left  AND
%right NOT

%start start

%% /* language grammar */

start
    : relation EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

relation
    : SELECT predicate '(' relation ')'
        { $$ = '{ "type": "select", "predicate": ' + $2 + ', "relation": ' + $4 + ' }'; }
    | PROJECT varlist '(' relation ')'
        { $$ = '{ "type": "project", "varlist": [' + $2 + '], "relation": ' + $4 + ' }'; }
    | ID
        { $$ = '{ "type": "ID", "name": "'  + yytext + '" }'; }
    | '(' relation ')' JOIN '(' relation ')'
        { $$ = '{ "type": "join", "left": ' + $2 + ', "right": ' + $6 + ' }'; }
    | '(' relation ')' JOIN predicate '(' relation ')'
        { $$ = '{ "type": "join", "left": ' + $2 + ', "right": ' + $7 + ', "predicate": ' + $5 + ' }'; }
    ;

predicate
    : predicate AND predicate
        { $$ = '{ "type": "and", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | predicate OR predicate
        { $$ = '{ "type": "or", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | NOT predicate
        { $$ = '{ "type": "not", "right": ' + $2 + ' }'; }
    | term '>' term
        { $$ = '{ "type": ">", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | term '<' term
        { $$ = '{ "type": "<", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | term '>=' term
        { $$ = '{ "type": ">=", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | term '<=' term
        { $$ = '{ "type": "<=", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | term '==' term
        { $$ = '{ "type": "==", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    | term '!=' term
        { $$ = '{ "type": "!=", "left": ' + $1 + ', "right": ' + $3 + ' }'; }
    ;

varlist
    : var ',' varlist
        { $$ = $1 + ',' + $3; }
    | var
        { $$ = $1; }
    ;

term
    : var
        { $$ = $1; }
    | NUMBER
        { $$ = yytext; }
    | STRING
        { $$ = '"' + yytext + '"'; }
    ;

var
    : ID
        { $$ = '"' + yytext + '"'; }
    | ID '.' ID
        { $$ = '"' + $1 + '.' + $3 + '"'; }
    ;
