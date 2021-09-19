extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var manual = {
	"main" : "[center]Table of Contents[/center]\n\n[url]Fundamentals[/url]\n\n[url]for[/url]\n[url]gosub[/url]\n[url]goto[/url]\n[url]if[/url]\n[url]input[/url]\n[url]len[/url]\n[url]let[/url]\n[url]mid$[/url]\n[url]next[/url]\n[url]print[/url]\n[url]rem[/url]\n[url]return[/url]",
	"Fundamentals" : "[center][b]Fundamentals[/b][/center]\n\nEvery line starts with a line number followed by the command to run. Commands and variables are case insentive.\n\nExamples\n\n10 print \"Hi\"\n20 let x = 10\n\nVariables store numbers and sequences of characters called strings. Due to system limitations only whole numbers are supported on this system. Variable names are one or more alphabetic characters. Strings must have a dollar sign at the end.\n\nExamples\n\n10 let welcome$=\"Hi\"\n20 let x = 10\n30 health = 20\n40 name$=\"Steve\"\n\n[url=main]Return to Table of Contents[/url]",
	"for" : "[center][b]FOR statement[/b][/center]\n\nfor <counter-variable>=<start-number> to <end-number>\n\nThe FOR command executes a series of statements for a specified number of times.\n\nExamples\n\n10 for x=1 to 10\n20 print \"Loop \" x\n30 next x\n\n[url=main]Return to Table of Contents[/url]",
	"gosub" : "[center][b]GOSUB statement[/b][/center]\n\ngosub <line>\n\nThe GOSUB command jumps to a subroutine at the specified line number. The subroutine will execute until a RETURN statement is found. Care must be taken to not create an infinite loop. If the line number does not exist, it will result in an error.\n\nExamples\n\n10 gosub 1000\n20 rem Do something else\n30 gosub 1000\n1000 print \"Processing..\"\n1010 return\n\n[url=main]Return to Table of Contents[/url]",
	"goto" : "[center][b]GOTO statement[/b][/center]\n\ngoto <line>\n\nThe GOTO command jumps to the specified line number. Care must be taken to not create an infinite loop. If the line number does not exist, it will result in an error.\n\nExamples\n\n10 input x\n20 if x > 10 then goto 10\n\n10 input x$\n20 if x$=\"quit\" then end\n30 goto 10\n\n[url=main]Return to Table of Contents[/url]",
	"if" : "[center][b]IF statement[/b][/center]\n\nif <equation> then <statement> [else <statement>]\n\nThe IF command executes a statement only if the equation is true. In the equation you may use equal (\"=\"), not equal (\"<>\"), greater than (\">\"), less than (\"<\"), greater than or equal (\">=\"), and less than or equal (\"<=\"). An optional else clause can be run in the case of a false statement.\n\nExamples\n\n10 if x > 10 then print \"Greater than 10\" else print x\n20 if a$=\"quit\" then end\n\n[url=main]Return to Table of Contents[/url]",
	"input" : "[center][b]INPUT statement[/b][/center]\n\ninput [<string>;]<variable>[,<variable>...]\n\nThe INPUT command reads in data. It can a text prompt to display before accepting input. A question mark is output as well regardless of whether a text prompt is included.\n\nExamples\n\n10 input x\n20 input a$,b$\n\n[url=main]Return to Table of Contents[/url]",
	"len" : "[center][b]LEN function[/b][/center]\n\nlen(<string>)\n\nThe LEN function gets the length of a string.\n\nExamples\n\n10 print len(\"HELLO WORLD\")\n20 a$ = \"abc\"\n30 for i = 1 to len(a$)\n40 print i\n50 next i\n\n[url=main]Return to Table of Contents[/url]",
	"let" : "[center][b]LET statement[/b][/center]\n\n[let] <variable>=<expression>\n\nThe LET command sets a variable to a value. The LET keyword is optional. This is not the same as a mathmatical equation. The expression is evaluated regardless of what the variable storing the value is. In mathematics \"x=x+1\" is nonsensical but in BASIC it would increment x by 1 and store the result in x. Operators available for expressions include addition (\"+\"), subtraction (\"-\"), multipication (\"*\"), division (\"/\"), modulus (\"%\"), logical and (\"+\"), and logical or (\"|\")\n\nExamples\n\n10 let welcome$ = \"Hello World\"\n20 let x = 10\n30 let y = x + 5\n40 greet$ = welcome$ + \" Chris\"\n50 area = x * y\n\n[url=main]Return to Table of Contents[/url]",
	"mid$" : "[center][b]MID$ function[/b][/center]\n\nmid$(<string>,<start-character>,<number-of-characters>)\n\nThe MID$ function cuts a segment out of a string. It returns a string starting at the position of the second argument. The string will be as long as the third argument.\n\nExamples\n\n10 a$ = \"HELLO WORLD\"\n20 print mid$(a$, 1, 5)\n30 print mid$(a$, 2, 1)\n\n[url=main]Return to Table of Contents[/url]",
	"next" : "[center][b]NEXT statement[/b][/center]\n\nnext <counter-variable>\n\nThe NEXT command increments the counter variable. If the value is below the maximum, the program execution will go back to the beginning of the FOR command. Using NEXT without a FOR command or after reaching the end value will result in an error.\n\nExamples\n\n10 for x=1 to 10\n20 print \"Loop \" x\n30 next x\n\n[url=main]Return to Table of Contents[/url]",
	"print" : "[center][b]PRINT statement[/b][/center]\n\nprint [<expression>] [[;|,]<expression>...]\n\nThe PRINT command outputs the arguments to the screen. The arguments may be seperated by a semicolon or comma. When specifying specific text to be printed it must be enclosed in double quotes. A comma between expressions will add a space to the output. If an argument's expression is invalid, an error message prints and execution aborts.\n\nA PRINT command moves to the beginning of the next line when finished.\n\nExamples\n\n10 print \"Hello World\"\n20 print 10 + 5\n30 b$ = \"Hello\"\n40 print b$,\"World\"\n\n[url=main]Return to Table of Contents[/url]",
	"rem" : "[center][b]REM statement[/b][/center]\n\nrem\n\nThe REM command does nothing. It allows you to add explaination to your code about what it is doing.\n\nExamples\n\n10 rem X and Y variables store the position of the robot.\n20 rem COST is stored in cents.\n\n[url=main]Return to Table of Contents[/url]",
	"return" : "[center][b]RETURN statement[/b][/center]\n\nreturn\n\nThe RETURN command finishes a subroutine started by GOSUB command. The program execution will go back to the line after the GOSUB command. Using RETURN without a GOSUB command end value will result in an error.\n\nExamples\n\n10 gosub 1000\n20 rem Do something else\n30 gosub 1000\n1000 print \"Processing..\"\n1010 return\n\n[url=main]Return to Table of Contents[/url]"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_text = manual["main"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RichTextLabel_meta_clicked(meta):
	bbcode_text = manual[meta]
