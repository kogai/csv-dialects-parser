%{
  open Syntax
  open Core
%}

%token <Syntax.info> CRLF
%token <Syntax.info> COMMA
%token <Syntax.info * string> FIELD
%token <Syntax.info * string> DQUOTE
%token <Syntax.info> EOF
%start <Syntax.t list> file

%%

/*
file = [header CRLF] record *(CRLF record) [CRLF]
header = name *(COMMA name)
record = field *(COMMA field)
name = field
field = (escaped / non-escaped)
escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
non-escaped = *TEXTDATA
COMMA = %x2C
CR = %x0D ;as per section 6.1 of RFC 2234 [2]
*/

file:
  | EOF { [] }
  | t = record { t }
record:
  | t = separated_list(COMMA, field) { t }
field:
  | t = escaped { t }
  | t = non_escaped { t }
escaped:
  | {[]}
non_escaped:
  | {[]}
