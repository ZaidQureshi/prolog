open Ast
open Parser


(* Takes a string s and returns the abstract syntax tree generated by lexing and parsing s *)
let parse s =
    let lexbuf = Lexing.from_string s in
        let ast = clause Lexer.token lexbuf in
            ast

(* Takes a string s and returns Some of an abstract syntax tree or None *)
let try_parse s =
    try Some (parse s) with
    | Error -> None

(* String conversion functions *)
let string_of_token t =
    match t with
    | INT    i  -> "INT "      ^ string_of_int i
    | FLOAT  f  -> "FLOAT "    ^ string_of_float f
    | STRING s  -> "STRING \"" ^ String.escaped s ^ "\""
    | ATOM   a  -> "ATOM \""   ^ String.escaped a ^ "\""
    | VAR    v  -> "VAR \""    ^ v ^ "\""
    | RULE      -> "RULE"
    | QUERY     -> "QUERY"
    | PERIOD    -> "PERIOD"
    | LPAREN    -> "LPAREN"
    | RPAREN    -> "RPAREN"
    | COMMA     -> "COMMA"
    | SEMICOLON -> "SEMICOLON"
    | EOF       -> "EOF"

let string_of_token_list tl =
    "[" ^ (String.concat "; " (List.map string_of_token tl)) ^ "]"

let string_of_const c =
    match c with
    | IntConst    i -> "IntConst "      ^ string_of_int i
    | FloatConst  f -> "FloatConst "    ^ string_of_float f
    | StringConst s -> "StringConst \"" ^ String.escaped s ^ "\""
    | BoolConst   b -> "BoolConst "     ^ string_of_bool b

let rec string_of_exp e =
    match e with
    | VarExp v -> "VarExp \"" ^ v ^ "\""
    | ConstExp c -> "ConstExp (" ^ (string_of_const c) ^ ")"
    | TermExp (f, args) ->
        let func = String.escaped f in
            "TermExp (\"" ^ func ^ "\", [" ^ (String.concat "; " (List.map string_of_exp args)) ^ "])"
    | ConjunctionExp (e1, e2) ->
        "ConjunctionExp (" ^ (string_of_exp e1) ^ ", " ^ (string_of_exp e2) ^ ")"
    | DisjunctionExp (e1, e2) ->
        "DisjunctionExp (" ^ (string_of_exp e1) ^ ", " ^ (string_of_exp e2) ^ ")"

let string_of_dec d =
    match d with
    | Clause (e1, e2) -> "Clause (" ^ (string_of_exp e1) ^ ", " ^ (string_of_exp e2) ^ ")"
    | Query e -> "Query (" ^ (string_of_exp e) ^ ")"

let string_of_db db =
    "[" ^ (String.concat "; " (List.map string_of_dec db)) ^ "]"

let print_db db =
    print_endline (string_of_db db)

let string_of_res r =
    raise (Failure "Not implemented yet")
