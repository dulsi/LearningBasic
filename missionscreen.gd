extends Node2D

signal missionselect_screen


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func go_mission_select():
	emit_signal("missionselect_screen")

func set_mission(missioninfo):
	$TextEdit.test_data = missioninfo["test_data"]
	$RightPanel/Mission/RichTextLabel.set_bbcode(missioninfo["description"])
