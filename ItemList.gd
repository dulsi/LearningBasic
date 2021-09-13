extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var missions = [
	{
		"name": "Restart the Power Plant", 
		"description": "[center][b]Restart the Power Plant[/b][/center]\n\nBattery backup is keeping the systems running at the moment but it won't last forever. Communication with Earth is spotty. They will be sending the alignment settings.\n\nRead in numbers. Discard anything less than zero. Zero means the end of content. Print every two valid numbers separated by a space.\n\nSample Input:\n-1\n6\n-3\n4\n8\n11\n-4\n0\n\nSample Output:\n6 4\n8 11",
		"test_data": [
			{
				"input" : [["4"], ["-12"], ["100"], ["-9"], ["-100"], ["23"], ["-12"], ["45"], ["56"], ["111"], ["-55"], ["-100"], ["-18"], ["-10"], ["1024"], ["-999"], ["1"], ["0"]],
				"output" : "4 100\n23 45\n56 111\n1024 1\n"
			}
		],
		"building": "6"
	},
	{
		"name": "Restore Communications", 
		"description": "[center][b]Restore Communications[/b][/center]\n\nMessages are getting scrambled but they are usually consistent for a short period of time. Earth will be sending the capital letter 'A' for the start of messages. If you use asc() you can determine how much the difference is between the 'A' you should have received and what you actually received.\n\nAfter calculating the difference read in strings. Iterate over the length of the string converting each letter and storing in a new string. mid$ and chr$ will be important for this task. Stop when the translated word is \"DONE\"\n\nSample Input:\nB\nIFMMP\nXPSME\nEPOF\n\nSample Output:\nHELLO\nWORLD",
		"test_data": [
			{
				"input" : [["G"], ["ZKYZ"], ["UL"], ["HXUGJIGYZ"], ["JUTK"]],
				"output" : "TEST\nOF\nBROADCAST\n"
			}
		],
		"building": "2"
	}
]

var complete = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in missions:
		add_item(i["name"])
		complete.push_back(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_activated(index):
	get_parent().set_mission(missions[index])

func set_mission_complete():
	complete[get_selected_items()[0]] = true
	print("Building" + missions[get_selected_items()[0]]["building"] + "_Good")
	get_parent().get_node("Building" + missions[get_selected_items()[0]]["building"] + "_Good").show()
	get_parent().get_node("Building" + missions[get_selected_items()[0]]["building"] + "_Bad").hide()
