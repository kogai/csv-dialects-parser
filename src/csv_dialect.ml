open Core

exception Unreachable

let to_string fields =
  fields
  |> List.map ~f:Syntax.show
  |> String.concat ~sep:"\n"

let write path content =
  let filename = match Filename.split_extension path with
    | filename, Some _ -> sprintf "%s.json" filename
    | _ -> raise Unreachable
  in
  print_endline content;
  Out_channel.write_all filename content

let run filename () =
  filename
  |> In_channel.create
  |> Lexing.from_channel
  |> Translate.translate filename
  |> to_string
  |> write filename

let () =
  Command.basic ~summary:"Parse and display CSV"
    Command.Spec.(empty +> anon ("filename" %: file))
    run
  |> Command.run
