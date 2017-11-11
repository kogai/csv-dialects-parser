{
open Core
open Lexing
open Parser

exception SyntaxError

let next_line lexbuf =
  let { lex_curr_p; lex_curr_pos; } = lexbuf in
  lexbuf.lex_curr_p <- {
    lex_curr_p with pos_bol = lex_curr_pos;
                    pos_lnum = lex_curr_p.pos_lnum + 1
  }

  let info { lex_curr_p; lex_start_pos; } =
    let { pos_fname; pos_lnum; pos_cnum; pos_bol; } = lex_curr_p in
    Syntax.create_info pos_fname pos_lnum (pos_cnum - pos_bol)

  let identifier lexbuf =
    Lexing.lexeme lexbuf
}

let white = [' ' '\t']+
let cr = '\r'
let lf = '\n'
let crlf = "\r\n"
let field = ['a'-'z' 'A'-'Z' '0'-'9' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule read =
  parse
  | white { read lexbuf }
  | crlf | cr | lf { next_line lexbuf; CRLF (info lexbuf) }
  | "," { COMMA (info lexbuf) }
  | field { FIELD ((info lexbuf), (Lexing.lexeme lexbuf)) }
  | _ { raise SyntaxError }
  | eof { EOF (info lexbuf) }
