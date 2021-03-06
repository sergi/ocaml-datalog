(* An Implementation of Datalog.
   Copyright (C) 2005 The MITRE Corporation

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

(* Datalog *)

(* The inference engine uses tabled logic programming (memoization) to ensure
 * that all queries terminate. The logical constants used by the
 * engine follow. *)

(* The input signature of the functor {!Datalog.Make}. *)
module type DatalogType = Hashtbl.HashedType

module type T =
sig
  (** The type of logical constants. *)
  type value

  (* The type of a term. *)
  type term

  val mkvar : string -> term

  (* Term constructors. *)
  val mkval : value -> term

  (* [spreadterm f g t] calls [f] if term [t] is a variable, and [g] if it
   * is a value. *)
  val spreadterm : (string -> 'a) -> (value -> 'a) -> term -> 'a

  (* The type of a literal. *)
  type literal

  (* Constructs a literal. *)
  val mkliteral : string -> term list -> literal

  val getpred : literal -> string

  (* Gets the parts of a literal. *)
  val getterms : literal -> term list

  (* The type of a clause. *)
  type clause

  (* Constructs a clause. *)
  val mkclause : literal -> literal list -> clause

  val gethead : clause -> literal

  (* Gets the parts of a clause. *)
  val getbody : clause -> literal list

  (* The type of a primitive implemented as a function. *)
  type primitive = int -> value list -> value list option

  (* Add a primitive. After [add_primitive symbol in_arity primitive],
   * the predicate symbol is bound to a predicate that takes in in_arity
   * values. When invoked, a predicate is given the number of output values
   * it is expected to produce, and a list of input values.  If the predicate
   * succeeds, it returns a list of values that are unified with terms at the
   * end of the query. A predicate signals failure by returning None. *)
  val add_primitive : string -> int -> primitive -> unit

  type theory
  (** The type of a theory. *)

  (* Create a theory. For best results, the integer should be on the order
   * of the expected number of clauses that make up the theory. The theory
   * will grow as needed. *)
  val create : int -> theory

  (* Return a copy of the given theory. *)
  val copy : theory -> theory

  exception Unsafe_clause

  val assume : theory -> clause -> unit
  (* Add a clause as an assumption of the theory.  Raise an exception if
   * clause is not safe. *)

  val retract : theory -> clause -> unit
  (** Retract a clause as an assumption of the theory. *)

  val prove : theory -> literal -> literal list
  (* Given a literal as a query, returns a list of instances of the query
   * that are derivable from the current theory. If the list is empty, the
   * query has no derivations, and is thus false. *)

end
(* The output signature of the functor {!Datalog.Make}. *)

(* Functor building an implementation of the Datalog structure. *)
module Make (D : DatalogType) : T with type value = D.t
