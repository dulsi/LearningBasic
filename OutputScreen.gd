extends TextEdit


var line = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_add_text(t):
	var s = str(t)
	var u = s.to_utf8()
	for i in range(len(s)):
		if u[i] == ord('\n'):
			line = line + 1
	text = text + s
	cursor_set_line(line)


func _on_clear_screen():
	text = ""
	line = 0
