
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?    return 'NUMBER'
("sigma")|(\\u03C3)     return 'SELECT'
(pi)|(\\u03C0)        return 'PROJECT'
(join)|(\\u22C8)      return 'JOIN'
(and)|(\\u2227)       return 'AND'
(or)|(\\u2228)        return 'OR'
(not)|(\\u00AC)       return 'NOT'
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
        { $$ = "{ type: 'select', predicate: " + $2 + ", relation: " + $4 + " }"; }
    | ID
        { $$ = "'" + yytext + "'"; }
    ;

predicate
    : predicate AND predicate
        { $$ = "{ type: 'and', left: " + $1 + ", right: " + $3 + " }"; }
    | predicate OR predicate
        { $$ = "{ type: 'or', left: " + $1 + ", right: " + $3 + " }"; }
    | NOT predicate
        { $$ = "{ type: 'not', right: " + $2 + " }"; }
    | term '>' term
        { $$ = "{ type: '>', left: " + $1 + ", right: " + $3 + " }"; }
    | term '<' term
        { $$ = "{ type: '<', left: " + $1 + ", right: " + $3 + " }"; }
    | term '>=' term
        { $$ = "{ type: '>=', left: " + $1 + ", right: " + $3 + " }"; }
    | term '<=' term
        { $$ = "{ type: '<=', left: " + $1 + ", right: " + $3 + " }"; }
    | term '==' term
        { $$ = "{ type: '==', left: " + $1 + ", right: " + $3 + " }"; }
    | term '!=' term
        { $$ = "{ type: '!=', left: " + $1 + ", right: " + $3 + " }"; }
    ;

term
    : var
        { $$ = $1; }
    | NUMBER
        { $$ = yytext; }
    ;

var
    : ID
        { $$ = "'" + yytext + "'"; }
    | ID '.' ID
        { $$ = "'" + $1 + "." + $2 + "'"; }
    ;
