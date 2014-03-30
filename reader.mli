(** A Reader for Datalog Programs *)

(** The readers generate Datalog formulas which assume that constants
   are represented as strings. *)

open Prover

(** Reads a Datalog program.  The argument is the name of a file.
   Standard input is used if the file name is "-". *)
val read_program : in_channel -> clause list * literal

(** Reads a Datalog clause from a string. *)
val read_clause_from_string : string -> clause

(** Reads a Datalog clause from a string. *)
val read_atom_from_string : string -> literal
