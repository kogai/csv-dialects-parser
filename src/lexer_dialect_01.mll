{
open Core
open Lexing
open Parser
open Syntax
}

let white = [' ' '\t']+
let cr = '\r'
let lf = '\n'
let crlf = "\r\n"
let comma = ','

let text_data = [^ ',' '\r' '\n'] [^ ',' '\r' '\n']*

rule read =
  parse
  | white { read lexbuf }
  | crlf { next_line lexbuf; CRLF (info lexbuf) }
  | comma { COMMA (info lexbuf) }
  | text_data { FIELD ((info lexbuf), (Lexing.lexeme lexbuf)) }
  | _ { raise SyntaxError }
  | eof { EOF (info lexbuf) }
