open Core

type t = string list
[@@deriving show]

(* filename * line * column *)
type info = string * int * int
[@@deriving show]

let show_info (file, line, column) = sprintf "%s:%d:%d" file line column
let create_info file line column = (file, line, column)
