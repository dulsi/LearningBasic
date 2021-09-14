extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var missions = [
	{
		"name": "Restart the Power Plant", 
		"description": "[center][b]Restart the Power Plant[/b][/center]\n\nBattery backup is keeping the systems running at the moment but it won't last forever. Communication with Earth is spotty. They will be sending the alignment settings.\n\nRead in numbers. Discard anything less than zero. Zero means the end of content. Print every two valid numbers separated by a space.\n\nSample Input:\n-1\n6\n-3\n4\n8\n11\n-4\n0\n\nSample Output:\n6 4\n8 11",
		"initial_code": "",
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
		"initial_code": "",
		"test_data": [
			{
				"input" : [["G"], ["ZKYZ"], ["UL"], ["HXUGJIGYZ"], ["JUTK"]],
				"output" : "TEST\nOF\nBROADCAST\n"
			}
		],
		"building": "2"
	},
	{
		"name": "Unlocking the Main Complex", 
		"description": "[center][b]Unlocking the Main Complex[/b][/center]\n\nThe main complex is in lockdown. You need to work with Jennifer to get the system running. She needs you to read in a number to variable \"x\". Then call the subroutine at line 1000 using gosub a number of times equal to the entered number.\n\nAfter a little bit Jennifer asks for some more help. She needs a subroutine at line 500 which multiples x by 2 and prints the result. Remember to call return command at the end.\n\nSample Input:\n5\n\nSample Output:\nSubroutine\n10\nSubroutine\n20\nSubroutine\n40\nSubroutine\n80\nSubroutine\n160",
		"initial_code": "\n\n1000 rem DO NOT MODIFY BELOW THIS LINE\n1010 print \"Subroutine\"\n1020 gosub 500\n1030 return\n",
		"test_data": [
			{
				"input" : [["G"], ["ZKYZ"], ["UL"], ["HXUGJIGYZ"], ["JUTK"]],
				"output" : "TEST\nOF\nBROADCAST\n"
			}
		],
		"building": "1"
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
	get_parent().get_node("Building" + missions[get_selected_items()[0]]["building"] + "_Good").show()
	get_parent().get_node("Building" + missions[get_selected_items()[0]]["building"] + "_Bad").hide()
