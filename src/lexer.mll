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
let dq = '"'
let dq2 = "\"\""

let text_data = [^ ',' '\r' '\n' '"'] [^ ',' '\r' '\n' '"']*
let escaped = text_data | comma | cr | lf | dq2
let text_data_dialect01 = [^ ',' '\r' '\n'] [^ ',' '\r' '\n']*

rule read_rfc4180 =
  parse
  | white { read_rfc4180 lexbuf }
  | crlf { next_line lexbuf; CRLF (info lexbuf) }
  | comma { COMMA (info lexbuf) }
  | dq { FIELD ((info lexbuf), (read_field (Buffer.create 16) lexbuf)) }
  | text_data { FIELD ((info lexbuf), (Lexing.lexeme lexbuf)) }
  | _ { raise SyntaxError }
  | eof { EOF (info lexbuf) }
and read_field buf =
  parse
  | dq { Buffer.contents buf }
  | dq2 {
    Buffer.add_char buf '"';
    read_field buf lexbuf
  }
  | escaped {
    Buffer.add_string buf (Lexing.lexeme lexbuf);
    read_field buf lexbuf
  }
  | _ { raise SyntaxError }
  | eof { raise SyntaxError }
and read_dialect01 =
  parse
  | white { read_dialect01 lexbuf }
  | crlf { next_line lexbuf; CRLF (info lexbuf) }
  | comma { COMMA (info lexbuf) }
  | text_data_dialect01 { FIELD ((info lexbuf), (Lexing.lexeme lexbuf)) }
  | _ { raise SyntaxError }
  | eof { EOF (info lexbuf) }
