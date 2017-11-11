open Core
open Lexing
open Yojson.Basic

type t = string list
exception SyntaxError

let show = String.concat ~sep:"\n"

let json_of_records xss = `List (
    List.map ~f:(fun xs ->
        `List (List.map ~f:(fun x ->
            `String (x)) xs)) xss
  )

let string_of_records records =
  records
  |> json_of_records
  |> pretty_to_string 

(* filename * line * column *)
type info = string * int * int
[@@deriving show]

let show_info (file, line, column) = sprintf "%s:%d:%d" file line column
let create_info file line column = (file, line, column)

let next_line lexbuf =
  let { lex_curr_p; lex_curr_pos; } = lexbuf in
  lexbuf.lex_curr_p <- {
    lex_curr_p with pos_bol = lex_curr_pos;
                    pos_lnum = lex_curr_p.pos_lnum + 1
  }

let info { lex_curr_p; lex_start_pos; } =
  let { pos_fname; pos_lnum; pos_cnum; pos_bol; } = lex_curr_p in
  create_info pos_fname pos_lnum (pos_cnum - pos_bol)

let identifier lexbuf = Lexing.lexeme lexbuf
