extends Node2D

signal missionscreen(missioninfo)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_mission(missioninfo):
	emit_signal("missionscreen", missioninfo)
