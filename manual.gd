extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var manual = {
	"main" : "[center]Table of Contents[/center]\n\n[url]for[/url]\n[url]goto[/url]\n[url]if[/url]\n[url]input[/url]\n[url]next[/url]\n[url]print[/url]",
	"for" : "[center][b]FOR statement[/b][/center]\n\nfor <counter-variable>=<start-number> to <end-number>\n\nThe FOR command executes a series of statements for a specified number of times.\n\nExamples\n\n10 for x=1 to 10\n20 print \"Loop \" x\n30 next x\n\n[url=main]Return to Table of Contents[/url]",
	"goto" : "[center][b]GOTO statement[/b][/center]\n\ngoto <line>\n\nThe GOTO command jumps to the specified line number. Care must be taken to not create an infinite loop. If the line number does not exist, it will result in an error.\n\nExamples\n\n10 input x\n20 if x > 10 then goto 10\n\n10 input x$\n20 if x$=\"quit\" then end\n30 goto 10\n\n[url=main]Return to Table of Contents[/url]",
	"if" : "[center][b]IF statement[/b][/center]\n\nif <equation> then <statement> [else <statement>]\n\nThe IF command executes a statement only if the equation is true. In the equation you may use equal (\"=\"), not equal (\"<>\"), greater than (\">\"), less than (\"<\"), greater than or equal (\">=\"), and less than or equal (\"<=\"). An optional else clause can be run in the case of a false statement.\n\nExamples\n\n10 if x > 10 then print \"Greater than 10\" else print x\n20 if a$=\"quit\" then end\n\n[url=main]Return to Table of Contents[/url]",
	"input" : "[center][b]INPUT statement[/b][/center]\n\ninput [<string>;]<variable>[,<variable>...]\n\nThe INPUT command reads in data. It can a text prompt to display before accepting input. A question mark is output as well regardless of whether a text prompt is included.\n\nExamples\n\n10 input x\n20 input a$,b$\n\n[url=main]Return to Table of Contents[/url]",
	"next" : "[center][b]NEXT statement[/b][/center]\n\nnext <counter-variable>\n\nThe NEXT command increments the counter variable. If the value is below the maximum, the program execution will go back to the beginning of the FOR command. Using NEXT without a FOR command or after reaching the end value will result in an error.\n\nExamples\n\n10 for x=1 to 10\n20 print \"Loop \" x\n30 next x\n\n[url=main]Return to Table of Contents[/url]",
	"print" : "[center][b]PRINT statement[/b][/center]\n\nprint [<expression>] [[;|,]<expression>...]\n\nThe PRINT command outputs the arguments to the screen. The arguments may be seperated by a semicolon or comma. When specifying specific text to be printed it must be enclosed in double quotes. A comma between expressions will add a space to the output. If an argument's expression is invalid, an error message prints and execution aborts.\n\nA PRINT command moves to the beginning of the next line when finished.\n\nExamples\n\n10 print \"Hello World\"\n20 print 10 + 5\n30 b$ = \"Hello\"\n40 print b$,\"World\"\n\n[url=main]Return to Table of Contents[/url]"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_text = manual["main"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RichTextLabel_meta_clicked(meta):
	bbcode_text = manual[meta]
