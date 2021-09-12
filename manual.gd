extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var manual = {
	"main" : "[center]Table of Contents[/center]\n\n[url]for[/url]\n[url]print[/url]",
	"for" : "[center][b]FOR statement[/b][/center]\n\nfor <counter-variable>=<start-number> to <end-number>\n\nThe FOR command executes a series of statements for a specified number of times.\n\nExamples\n\n10 for x=1 to 10\n20 print \"Loop \" x\n30 next x\n\n[url=main]Return to Table of Contents[/url]",
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
