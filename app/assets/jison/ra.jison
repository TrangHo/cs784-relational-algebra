
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?    return 'NUMBER'
("sigma")|"σ"         return 'SELECT'
("pi")|"π"            return 'PROJECT'
("join")|"⋈"         return 'JOIN'
("and")|"∧"           return 'AND'
("or")|"∨"            return 'OR'
("not")|"¬"           return 'NOT'
"("                   return '('
")"                   return ')'
"=="                  return '=='
"!="                  return '!='
"<"                   return '<'
">"                   return '>'
"<="                  return '<='
">="                  return '>='
"."                   return 'DOT'
","                   return 'COMMA'
[a-zA-Z_]+            return 'ID'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */
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
    | ID
        { $$ = '{ "type": "ID", "name": "'  + yytext + '" }'; }
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

term
    : var
        { $$ = $1; }
    | NUMBER
        { $$ = yytext; }
    ;

var
    : ID
        { $$ = '"' + yytext + '"'; }
    | ID '.' ID
        { $$ = '"' + $1 + '.' + $2 + '"'; }
    ;
