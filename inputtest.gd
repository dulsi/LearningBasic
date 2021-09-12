extends Node
class_name InputTest

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = []
var data_index = 0
var item_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func first_input():
	data_index = 0
	item_index = 0

func get_input():
	if data.size() <= data_index:
		return ""
	if data[data_index].size() <= item_index:
		data_index = data_index + 1
		item_index = 0
		if data.size() <= data_index:
			return ""
	item_index = item_index + 1
	return data[data_index][item_index - 1]

func finish_line():
	data_index = data_index + 1
	item_index = 0
