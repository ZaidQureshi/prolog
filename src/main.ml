open Ast
open Common
open Lexer
open Parser
open Evaluator


(* Try to detect if something is getting piped in *)
let is_interactive = 0 = (Sys.command "[ -t 0 ]")

let _ =
  (if is_interactive
      then print_endline "\nWelcome to the Prolog Interpreter \n"
      else ());
  let rec loop db =
  print_db db;
  try
    let lexbuf = Lexing.from_channel stdin
    in (if is_interactive 
          then (print_string "> "; flush stdout)
          else ());
       (try
         
          let dec = clause (fun lb -> match Lexer.token lb with 
                                    | EOF -> raise Lexer.EndInput
				    | r -> r)
                    lexbuf 
          in 
             let (newdb,res) = eval_dec (dec,db) in
             (match res with  None ->  loop newdb
                            | _ -> raise (Failure "Not impelmented yet"))
            
        with Failure s -> (print_newline();
			   print_endline s;
                           print_newline();
                           loop db)
           | Parsing.Parse_error ->
             (print_string "\ndoes not parse\n";
              loop db)); 
  with Lexer.EndInput -> exit 0
 in (loop [])
