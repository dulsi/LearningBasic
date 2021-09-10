extends TextEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var input = []
var inptr = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func first_input():
	inptr = 0
	input = text.to_utf8()

func is_whitespace(c):
	if c == ord(' ') || c == ord('\t') || c == ord('\n'):
		return true
	else:
		return false

func get_input():
	while inptr < input.size() && is_whitespace(input[inptr]):
		inptr = inptr + 1
	if inptr == input.size():
		return ""
	var startptr = inptr
	while inptr < input.size() && !is_whitespace(input[inptr]):
		inptr = inptr + 1
	return input.subarray(startptr, inptr - 1).get_string_from_utf8()

func finish_line():
	while inptr < input.size() && input[inptr] != ord('\n'):
		inptr = inptr + 1
	if inptr < input.size():
		inptr = inptr + 1
