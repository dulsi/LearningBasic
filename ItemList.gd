extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var missions = [
	{
		"name": "Realign Solar Panels", 
		"description": "[center][b]Realign Solar Panels[/b][/center]\n\nBattery backup is keeping the systems running at the moment but it won't last forever. Communication with Earth is spotty. They will be sending the alignment settings.\n\nRead in numbers. Discard anything less than zero. Zero means the end of content. Print every two valid numbers separated by a space.\n\nSample Input:\n-1\n6\n-3\n4\n8\n11\n-4\n0\n\nSample Output:\n6 4\n8 11",
		"test_data": [
			{
				"input" : [["4"], ["-12"], ["100"], ["-9"], ["-100"], ["23"], ["-12"], ["45"], ["56"], ["111"], ["-55"], ["-100"], ["-18"], ["-10"], ["1024"], ["-999"], ["1"], ["0"]],
				"output" : "4 100\n23 45\n56 111\n1024 1\n"
			}
		]
	}
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in missions:
		add_item(i["name"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_activated(index):
	get_parent().set_mission(missions[index])
