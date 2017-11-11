%{
  open Syntax
  open Core
%}

%token <Syntax.info> CRLF
%token <Syntax.info> COMMA
%token <Syntax.info * string> FIELD
%token <Syntax.info> EOF
%start <Syntax.t> file

%%

file:
  | EOF { [] }
  | t = record { t }
record:
  | t = separated_list(COMMA, field) CRLF { t }
field:
  | t = non_escaped { t }
non_escaped:
  | t = FIELD { Tuple2.get2 t }
