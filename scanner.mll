(* A lexical analyzer for Datalog input. *)

{

open Parser

(* Returns a tuple with the current line number and the start and end
 * characters for the current lexeme *)
let lexeme_place lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  let start =
    Lexing.lexeme_start lexbuf - pos.Lexing.pos_bol + 1 in
  let finish =
    Lexing.lexeme_end lexbuf - pos.Lexing.pos_bol + 2 in
  (pos.Lexing.pos_lnum, start, finish)

(* Convert the external version of string into the internal representation *)
let strip str =
  Scanf.sscanf str "%S" (fun s -> s)
}

let newline = '\n' | '\r' | "\r\n"
let var_start = ['A'-'Z' '_']
let val_start = ['a'-'z' '0'-'9']
let part = ['A'-'Z' 'a'-'z' '_' '0'-'9']

let identifier = var_start part*
let value = val_start part*
let str_chars = [^ '"' '\\'] | "\\\\" | "\\\""  | "\\'"
| "\\n" | "\\r" | "\\t" | "\\b"
| "\\" [ '0'-'9' ]  [ '0'-'9' ]  [ '0'-'9' ]
let str = '"' str_chars* '"'

rule token = parse
  [' ' '\t']                { token lexbuf }
| newline                   { Lexing.new_line lexbuf; token lexbuf }
(* skip comments starting with the percent sign '%' *)
| '%' [^ '\r' '\n' ]* newline { Lexing.new_line lexbuf; token lexbuf }
| '('                       { LPAREN }
| ')'                       { RPAREN }
| ','                       { COMMA }
| '?'                       { QUESTION }
| '.'                       { PERIOD }
| '='                       { EQUAL }
| ":-"                      { IMPLY }
| identifier                { VAR(Lexing.lexeme lexbuf) }
| value                     { VAL(Lexing.lexeme lexbuf) }
| str                       { VAL(strip(Lexing.lexeme lexbuf)) }
| eof                       { EOF }
