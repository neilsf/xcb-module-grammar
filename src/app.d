import pegged.grammar;
import std.stdio;

/**
 * This program generates pre-compiled grammar for XC=BASIC
 *
 * Usage: ./xcb-module-grammar > ../../source/language/grammar.d
 */

void main(string[] args)
{
    string s = "module language.grammar;\n\nimport pegged.grammar;\n\n";
    s ~= grammar(`
        XCBASIC:
            Program <- Line (NL+ Line)* EOI
            Line < :WS? Line_id :WS? Statements?
            
            Statements < Statement :WS? (":" :WS? Statement :WS?)*

            Statement < Const_stmt / Let_stmt / Print_stmt / If_stmt / Goto_stmt / Input_stmt / Gosub_stmt / Call_stmt /
                        Rem_stmt / Poke_stmt / For_stmt / Next_stmt / Dim_stmt / Charat_stmt / Data_stmt / Textat_stmt / Incbin_stmt /
                        Include_stmt / Sys_stmt / Load_stmt / Save_stmt / Randomize_stmt /
                        Origin_stmt / Swap_stmt / Locate_stmt / On_stmt / Error_stmt / Wait_stmt / Watch_stmt /
                        Pragma_stmt / Memset_stmt / Memcpy_stmt / Memshift_stmt / Open_stmt / Close_stmt / Get_stmt /
                        If_sa_stmt / Else_stmt / Endif_stmt / Disableirq_stmt / Enableirq_stmt /
                        Fun_stmt / Endfun_stmt / Return_fn_stmt / Return_stmt / Exitfun_stmt / Do_stmt / Loop_stmt /
                        Asm_stmt / Endasm_stmt / Print_hash_stmt / Write_stmt / Read_stmt /
                        Cont_stmt /  Exit_do_stmt / Exit_for_stmt / Type_stmt / Field_def / Endtype_stmt / End_stmt /
                        Screen_stmt / Cls_stmt
            Const_stmt <    ("shared"i :WS)? "const"i :WS? Var :WS? "=" :WS? Number
            Let_stmt <      ("let"i / eps) :WS? Accessor :WS? "=" :WS? Expression
            Print_stmt <    "print"i :WS? PrintableList :WS? ";"?
            Print_hash_stmt < "print"i :WS? "#" :WS? ExprList :WS? ";"?
            Write_stmt      < "write"i :WS? "#" :WS? ExprList
            Read_stmt       < "read"i :WS? "#" :WS? Expression  :WS? "," :WS? AccessorList
            If_stmt <       "if"i :WS Expression :WS "then"i :WS Statements :WS ("else"i :WS Statements)?
            If_sa_stmt <    "if"i :WS Expression :WS "then"i
            Else_stmt <     "else"i
            Endif_stmt <    "end if"i
            Goto_stmt <     "goto"i :WS (Label_ref / Unsigned)
            Error_stmt <    "error"i :WS Expression
            Swap_stmt <     "swap"i :WS Accessor :WS? "," :WS? Accessor
            Input_stmt <    "input"i :WS (("#" :WS? Expression :WS? ",")  / (String :WS? ";"))? :WS? Accessor :WS? ";"?
            Gosub_stmt <    "gosub"i :WS (Label_ref / Unsigned)
            Call_stmt <     "call"i :WS Accessor
            Return_stmt <   "return"i
            Return_fn_stmt < "return"i :WS Expression
            Poke_stmt <     "poke"i :WS Expression :WS? "," :WS? Expression
            Do_stmt <       "do"i (:WS ("while"i / "until"i) :WS Expression)?
            Loop_stmt <     "loop"i (:WS ("while"i / "until"i) :WS Expression)?
            Cont_stmt <     "continue"i :WS ("for"i / "do"i)?
            Exit_do_stmt <  "exit do"i
            Rem_stmt <      ("'" / "rem"i) ~((!eol .)*)
            For_stmt <      "for"i :WS Varnosubscript :WS? "=" :WS? Expression :WS? "to"i :WS? Expression (:WS? "step"i :WS? Expression)?
            Next_stmt <     "next"i :WS Varname?
            Exit_for_stmt < "exit for"i
            Dim_stmt <      ("dim"i / "static"i) :WS (Varattrib :WS)* Vardef (:WS? "," :WS? Vardef)* (:WS? Varattrib :WS)*
                Varattrib < "fast"i / "shared"i
                Vardef < Var (:WS? :"@" :WS? (Number / Label_ref))?
            Data_stmt <     ("shared"i :WS)? "data"i :WS Vartype :WS? Datalist
            Charat_stmt <   "charat"i :WS ExprList
            Textat_stmt <   "textat"i :WS ExprList
            Screen_stmt <   "screen"i :WS Expression
            Cls_stmt <      "cls"i (:WS Expression)?
            Asm_stmt <      "asm"i
            Endasm_stmt <   "end asm"i
            Incbin_stmt <   "incbin"i :WS String
            Include_stmt <  "include"i :WS String
            Exitfun_stmt <  "exit function"i  / "exit sub"i
            Endfun_stmt <   "end function"i / "end sub"i
            Fun_stmt <      ("declare"i :WS)? ("function"i / "sub"i) :WS Varnosubscript :WS? :"(" :WS? VarList? :WS? :")" (:WS Funcattrib)*
                Funcattrib < "private"i / "shared"i / "static"i / "overload"i / "inline"i
            Sys_stmt <      "sys"i :WS Expression (:WS? "fast"i)?
            Load_stmt <     "load"i :WS ExprList
            Save_stmt <     "save"i :WS ExprList
            Origin_stmt <   "origin"i :WS Number
            Locate_stmt <   "locate"i :WS Expression :WS? "," :WS? Expression
            On_stmt <       "on"i :WS (Expression / "error"i) :WS? Branch_type :WS? Label_ref (:WS? "," :WS? Label_ref)*
                Branch_type < "goto"i / "gosub"i
            Wait_stmt <     "wait"i :WS? Expression :WS? "," :WS? Expression (:WS? "," :WS? Expression)?
            Watch_stmt <    "watch"i :WS? Expression :WS? "," :WS? Expression
            Pragma_stmt <   "pragma"i :WS? Id :WS? "=" :WS? Number
            Memset_stmt <   "memset"i :WS? ExprList
            Memcpy_stmt <   "memcpy"i :WS? ExprList
            Memshift_stmt < "memshift"i :WS? ExprList
            Disableirq_stmt < "disableirq"i
            Enableirq_stmt <  "enableirq"i
            Randomize_stmt <  "randomize"i :WS Expression
            Open_stmt < "open"i :WS ExprList
            Get_stmt < "get"i (:WS? "#" :WS? Expression :WS? ",")? :WS? Var
            Close_stmt < "close"i :WS Expression
            Type_stmt < "type"i :WS Id
            Field_def < Var
            Endtype_stmt < "end type"i
            End_stmt <      "end"i

            ExprList < Expression :WS? ("," :WS? Expression)*
            AccessorList < Accessor :WS? ("," :WS? Accessor)*
            PrintableList < Expression :WS? (:WS? (TabSep / NlSupp) :WS? Expression)* NlSupp?
            TabSep < ","
            NlSupp < ";"
            VarList < Var (:WS? "," :WS? Var)*
            Datalist < (Number / String) (:WS? "," :WS? (Number / String) :WS?)*

            Expression < Relation (:WS? BW_OP :WS? Relation :WS?)*
            Relation < Simplexp (:WS? REL_OP :WS? Simplexp :WS?)?
            Simplexp < Term (:WS? E_OP :WS? Term :WS?)*
            Term < Factor (:WS? T_OP :WS? Factor :WS?)*
            Factor < (UN_OP? :WS? Accessor) / Number / (UN_OP? :WS? Parenthesis) / String / (UN_OP? :WS? Expression) / (UN_OP? :WS? Address)
            
            UN_OP < ("-" / ("not"i :WS))
            T_OP < ("*" / "/" / "mod"i)
            E_OP < ("+" / "-")
            BW_OP < ("and"i / "or"i / "xor"i)
            REL_OP < "<" | "<=" | "=" | "<>" | ">" | ">="

            Parenthesis < :"(" :WS? Expression :WS? :")"

            Varnosubscript < Varname Vartype?
            Var < Varname Subscript? Vartype?
            VarnamePattern <~ [a-zA-Z_] [a-zA-Z0-9_]* "$"?
            Varname <- !(Reserved !VarnamePattern) VarnamePattern
            Address < "@" Accessor

            Accessor < Varname :WS? Subscript? (:"." Varname)* Subscript?

            Id <- [a-zA-Z_] [a-zA-Z_0-9]*
            Str_typeLen <- "*" :WS? Number
            Vartype <- (:WS :"as"i :WS Id (:WS? Str_typeLen)?) / eps
            Subscript <- "(" :WS? Expression? (:WS? "," :WS? Expression)* :WS? ")"
            String < doublequote (!doublequote . / ^' ')* doublequote

            Unsigned   < [0-9]+
            Decimal    < Unsigned "d"
            Integer    < "-"? Unsigned
            Hexa       < "$" [0-9a-fA-F]+
            Binary     < "%" ("0" / "1")+
            Scientific < Floating ('e' / 'E' ) Integer
            Floating   < "-"? Unsigned "." Unsigned
            Charlit    < ("'{" [a-zA-Z_0-9]+ "}'") / ("'" . "'")

            Number < (Decimal / Scientific / Floating / Integer / Hexa / Binary / Charlit)

            Label < [a-zA-Z_] [a-zA-Z_0-9]* ":"
            Label_ref < [a-zA-Z_] [a-zA-Z_0-9]*

            Line_id < (Label / Unsigned / eps)

            Reserved < ("const"i / "let"i / "print"i / "if"i / "then"i / "goto"i / "input"i / "gosub"i / "return"i / "call"i /
                         "end"i / "rem"i / "for"i / "to"i / "next"i / "dim"i / "data"i / "charat"i / "textat"i /
                         "incbin"i /  "sys"i / "and"i / "origin"i / "or"i / "load"i / "save"i / "ferr"i / "sub"i / "function"i /
                         "asm"i / "endasm"i / "locate"i / "wait"i / "watch"i / "pragma"i / "memset"i / "memcpy"i / "memshift"i /
                         "while"i / "endwhile"i / "repeat"i / "until"i / "disableirq"i / "enableirq"i / "step"i
                         / "randomize"i / "open"i / "close"i / "get"i / "error"i / "mod"i / "read"i / "write"i /
                         "screen"i / "cls"i)
            WS < (space / "~" ('\r' / '\n' / '\r\n')+ )*
            EOI < !.

            NL <- !"~" ('\r' / '\n' / '\r\n')+
            Spacing <- :('\t')*
        `);
    writeln(s);
}

