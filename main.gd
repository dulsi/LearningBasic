extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Basic_missionselect_screen(complete, code):
	$Basic.hide()
	if complete:
		$MissionSelect.set_complete()
	$MissionSelect.set_code(code)
	$MissionSelect.show()


func _on_MissionSelect_missionscreen(missioninfo, initial_code):
	$MissionSelect.hide()
	$Basic.set_mission(missioninfo, initial_code)
	$Basic.show()
