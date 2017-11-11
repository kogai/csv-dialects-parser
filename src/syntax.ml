open Core

type t = string list
let show = String.concat ~sep:"\n"

(* filename * line * column *)
type info = string * int * int
[@@deriving show]

let show_info (file, line, column) = sprintf "%s:%d:%d" file line column
let create_info file line column = (file, line, column)
