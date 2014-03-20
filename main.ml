open Core.Std
open Prover
open Reader

let get_inchan = function
  | "-"      -> In_channel.stdin
  | filename -> In_channel.create ~binary:true filename


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

    (** display output *)
    let show atom =
      print_atom atom;
      Format.print_string ".";
      Format.print_newline() in

    List.iter atoms show ;

    exit 0

  with Failure s ->
    prerr_string s;
    prerr_newline();
    exit 1

let command =
  Command.basic
    ~summary:"Datalog 2 Command Line Interpreter"
    ~readme:(fun () -> "More detailed information")
    Command.Spec.(
      empty
      +> anon (maybe_with_default "-" ("filename" %: file))
    )
    run

let () =
  Command.run ~version:"1.0" ~build_info:"RWO" command
