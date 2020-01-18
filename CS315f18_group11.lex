%x PREDICATE
%{
int lineCount = 1;
%}
letter [a-zA-Z]
integer [0-9]
symbols [\?\@\[\]\\\^\_\}\{\']
alphanumeric ({letter}|{integer}|{symbols})
%%
\n { 
	lineCount++;	
}
go { return (PROG_BEGIN); }
finish { return (PROG_END); }
pandaMain { return (MAIN); }
if { return (IF); } 
ifn't { return (ELSE); }
cycle { return (WHILE); }
readonly { return (CONSTANT); }
return { return (RETURN); }
predicate { return (PREDICATE); BEGIN (PREDICATE); }
<PREDICATE>[ \t]{letter}{alphanumeric}* { return (PREDICATE_NAME); BEGIN (INITIAL); }
\${letter}{alphanumeric}* { return (PREDICATE_NAME); }
input { return (INPUT); }
output { return (OUTPUT); }
true { return (TRUE); }
false { return (FALSE); }
unknown { return (UNKNOWN); }
{letter}{alphanumeric}* { return (IDENTIFIER); }
\#.*\# { return (COMMENT); }
{integer} { return (INT); }
{letter}? { return (LETTER); }
\".*\" { return (STRING); }
\'.?\'  { return (CHAR); }
\=\= { return (ASSIGN_OP); }
\=\=\=  { return (EQUALITY_OP); }
\( { return (LP); }
\) { return (RP); }
\{ { return (LCB); }
\} { return (RCB); }
\[  { return (LSQB); }
\]  { return (RSQB); }
\; { return (SEMICOLON); }
\| { return (OR_OP); }
\$ { return(DOLAR);}
\& { return (AND_OP); }
\!  { return (NOT_OP); }
\, { return (CM); }
\<\=\=\> { return (EQUIVALENCE_OP); }
\=\=\> { return (IMPLIES_OP); }
%%
int yywrap() { return 1; }
