open Core.Std
open Core_extended.Std
open Prover
open Reader

let get_inchan = function
  | "-"      -> In_channel.stdin
  | filename -> In_channel.create ~binary:true filename

let show atom =
  print_atom atom;
  Format.print_string ".";
  Format.print_newline()

let run filename =
  try

    (** read input *)
    let (clauses, atom) = Reader.read_program (get_inchan filename) in

    (** load assumptions *)
    let theory = create 128 in

    List.iter clauses (assume theory);

    (** run query *)
    let atoms = prove theory atom in

    Format.set_formatter_out_channel stdout;

    List.iter atoms show ;

    exit 0

  with Failure s ->
    prerr_string s;
    prerr_newline();
    exit 1

let rec loop f theory =
  match f () with
  | None -> ()
  | Some line ->
    try
      let clause = Reader.read_clause_from_string line in
      assume theory clause;
      loop f theory
    with Failure s ->
      let atom = Reader.read_atom_from_string line in
      let atoms = prove theory atom in

      Format.set_formatter_out_channel stdout;
      List.iter atoms show;
      exit 1

let command =
  Command.basic
    ~summary:"Datalog 2 Command Line Interpreter"
    ~readme:(fun () -> "More detailed information")
    Command.Spec.(
      empty
      +> anon (maybe_with_default "-" ("filename" %: file))
    )
    (fun filename () ->
       let theory = create 128 in
       match filename with
       | "-" -> loop (Readline.input_line) theory
       | _ -> run filename
    )

let () =
  Command.run ~version:"1.0" ~build_info:"RWO" command
