extends Node2D

signal missionscreen(missioninfo, initial_code)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_mission(missioninfo, initial_code):
	emit_signal("missionscreen", missioninfo, initial_code)

func set_complete():
	$ItemList.set_mission_complete()

func set_code(code):
	$ItemList.set_mission_code(code)
