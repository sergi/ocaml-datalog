(* A reader for Datalog programs. *)

open Core.Std
(* Much of this code is dedicated to showing the location of an error
   in the input. *)

let report_error file_name lexbuf msg =
  let (lineno, start, finish) =
    Scanner.lexeme_place lexbuf in
  let msg =
    Printf.sprintf
      "File \"%s\", line %d, characters %d-%d: %s"
      file_name lineno start finish msg in
  failwith msg

let report_parse_error file_name lexbuf =
  report_error file_name lexbuf "syntax error"

(* Reads a Datalog program.  The argument is the name of the file. Standard
 * input is used if the file name is "-". *)
let read_program chan =
  let lexbuf = Lexing.from_channel chan in
  try
    let prog = Parser.program Scanner.token lexbuf in
    In_channel.close chan;
    prog
  with
  | Parsing.Parse_error ->
    In_channel.close chan;
    report_parse_error "placeholder" lexbuf
  | Failure s ->
    In_channel.close chan;
    report_error "placeholder" lexbuf s

let read_clause_from_string str =
  let lexbuf = Lexing.from_string str in
  try
    Parser.a_clause Scanner.token lexbuf
  with
  | Parsing.Parse_error -> report_parse_error "-" lexbuf
  | Failure s -> report_error "-" lexbuf s

let read_atom_from_string str =
  let lexbuf = Lexing.from_string str in
  try
    Parser.a_query Scanner.token lexbuf
  with
  | Parsing.Parse_error -> report_parse_error "-" lexbuf
  | Failure s -> report_error "-" lexbuf s

