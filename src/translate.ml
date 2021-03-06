open Core
open Lexing

let rec parse lexbuf =
  match Parser.file Lexer.read_dialect01 lexbuf with
  | [] -> []
  | field -> field::(parse lexbuf)

let translate filename lexbuf =
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  try
    parse lexbuf
  with
  | Syntax.SyntaxError as e ->
    Printf.fprintf stderr "Syntax error [%s] @%s\n" (Lexing.lexeme lexbuf) (Syntax.show_info (Syntax.info lexbuf));
    raise @@ e
  | Parser.Error as e ->
    Printf.fprintf stderr "Parse error [%s] @%s\n" (Lexing.lexeme lexbuf) (Syntax.show_info (Syntax.info lexbuf));
    raise @@ e
