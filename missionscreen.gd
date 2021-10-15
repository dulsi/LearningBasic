extends Node2D

signal missionselect_screen(complete)

var building
var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func go_mission_select():
	$ResultDialog.hide()
	emit_signal("missionselect_screen", complete)

func go_editor():
	$ResultDialog.hide()

func set_mission(missioninfo):
	$TextEdit.initial_code = missioninfo["initial_code"]
	$TextEdit.set_text($TextEdit.initial_code)
	$TextEdit.test_data = missioninfo["test_data"]
	$RightPanel/Mission/RichTextLabel.set_bbcode(missioninfo["description"])
	complete = false

func set_complete():
	complete = true
	$ResultDialog/ColorRect/Label.set_text("Success!")
	$ResultDialog.show()

func set_failed():
	$ResultDialog/ColorRect/Label.set_text("Failed!")
	$ResultDialog.show()
