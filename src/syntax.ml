open Core
open Yojson.Basic

type t = string list

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
