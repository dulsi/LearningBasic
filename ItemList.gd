extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var missions = [
	{
		"name": "Restart the Power Plant", 
		"description": "[center][b]Restart the Power Plant[/b][/center]\n\nBattery backup is keeping the systems running at the moment but it won't last forever. Communication with Earth is spotty. They will be sending the alignment settings.\n\nRead in numbers. Discard anything less than zero. Zero means the end of content. Print every two valid numbers separated by a space.\n\nSample Input:\n-1\n6\n-3\n4\n8\n11\n-4\n0\n\nSample Output:\n6 4\n8 11",
		"initial_code": "",
		"sample_input": "-1\n6\n-3\n4\n8\n11\n-4\n0\n",
		"sample_output": "6 4\n8 11",
		"test_data": [
			{
				"input" : [["4"], ["-12"], ["100"], ["-9"], ["-100"], ["23"], ["-12"], ["45"], ["56"], ["111"], ["-55"], ["-100"], ["-18"], ["-10"], ["1024"], ["-999"], ["1"], ["0"]],
				"output" : "4 100\n23 45\n56 111\n1024 1\n",
				"cheat" : "10 input x\n20 if x < 0 then goto 10\n30 if x = 0 then end\n40 input y\n50 if y < 0 then goto 40\n60 if y = 0 then end\n70 print x, y\n80 goto 10\n"
			}
		],
		"building": "6"
	},
	{
		"name": "Restore Communications", 
		"description": "[center][b]Restore Communications[/b][/center]\n\nMessages are getting scrambled but they are usually consistent for a short period of time. Earth will be sending the capital letter 'A' for the start of messages. If you use asc() you can determine how much the difference is between the 'A' you should have received and what you actually received.\n\nAfter calculating the difference read in strings. Iterate over the length of the string converting each letter and storing in a new string. mid$ and chr$ will be important for this task. Stop when the translated word is \"DONE\"\n\nSample Input:\nB\nIFMMP\nXPSME\nEPOF\n\nSample Output:\nHELLO\nWORLD",
		"initial_code": "",
		"sample_input": "B\nIFMMP\nXPSME\nEPOF\n",
		"sample_output": "HELLO\nWORLD",
		"test_data": [
			{
				"input" : [["G"], ["ZKYZ"], ["UL"], ["HXUGJIGYZ"], ["JUTK"]],
				"output" : "TEST\nOF\nBROADCAST\n",
				"cheat" : "10 input a$\n20 diff = asc(\"A\") - asc(a$)\n30 input c$\n40 d$ = \"\"\n50 for i = 1 to len(c$)\n60 d$ = d$ + chr$(asc(mid$(c$, i, 1)) + diff)\n70 next i\n80 if d$ = \"DONE\" then end\n90 print d$\n100 goto 30\n"
			}
		],
		"building": "2"
	},
	{
		"name": "Unlocking the Main Complex", 
		"description": "[center][b]Unlocking the Main Complex[/b][/center]\n\nThe main complex is in lockdown. You need to work with Jennifer to get the system running. She needs you to read in a number to variable \"x\". Then call the subroutine at line 1000 using gosub a number of times equal to the entered number.\n\nAfter a little bit Jennifer asks for some more help. She needs a subroutine at line 500 which multiples x by 2 and prints the result. Remember to call return command at the end.\n\nSample Input:\n5\n\nSample Output:\nSubroutine\n10\nSubroutine\n20\nSubroutine\n40\nSubroutine\n80\nSubroutine\n160",
		"initial_code": "\n\n1000 rem DO NOT MODIFY BELOW THIS LINE\n1010 print \"Subroutine\"\n1020 gosub 500\n1030 return\n",
		"sample_input": "5\n",
		"sample_output": "Subroutine\n10\nSubroutine\n20\nSubroutine\n40\nSubroutine\n80\nSubroutine\n160",
		"test_data": [
			{
				"input" : [["3"]],
				"output" : "6\nEngernizer 2\n4\n8\nEngernizer 2\n4\n8\nEngernizer 2\n4\n",
				"match": "1000 rem DO NOT MODIFY BELOW THIS LINE\n1010 print \"Subroutine\"\n1020 gosub 500\n1030 return",
				"replace" : "1000 gosub 500\n1010 x = 2\n1020 print \"Engernizer\", x\n1030 gosub 500\n1040 return",
				"cheat" : "10 input x\n20 for i = 1 to x\n30 gosub 1000\n40 next i\n50 end\n\n500 x = x * 2\n510 print x\n520 return\n\n\n1000 rem DO NOT MODIFY BELOW THIS LINE\n1010 print \"Subroutine\"\n1020 gosub 500\n1030 return\n"
			}
		],
		"building": "1"
	}
]

var complete = []
var code = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in missions:
		add_item(i["name"])
		complete.push_back(false)
		code.push_back(i["initial_code"])
#	ScormLoad()
	FileLoad()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_activated(index):
	get_parent().set_mission(missions[index], code[index])

func process_mission_complete(i):
	complete[i] = true
	get_parent().get_node("Building" + missions[i]["building"] + "_Good").show()
	get_parent().get_node("Building" + missions[i]["building"] + "_Bad").hide()

func set_mission_complete():
	process_mission_complete(get_selected_items()[0])
	ScormSave()
	FileSave()

func set_mission_code(new_code):
	code[get_selected_items()[0]] = new_code
	FileSave()

func FileSave():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(complete))
	save_game.store_line(to_json(code))
	save_game.close()

func FileLoad():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	save_game.open("user://savegame.save", File.READ)
	var complete2 = parse_json(save_game.get_line())
	for i in range(0, complete2.size() - 1):
		if complete2[i]:
			process_mission_complete(i)
	var code2 = parse_json(save_game.get_line())
	for i in range(0, code2.size() - 1):
		code[i] = code2[i]

func ScormSave():
#	for i in range(0, complete.size() - 1):
#		if complete[i]:
#			JavaScript.eval("ScormProcessSetValue('cmi.objectives." + String(i) + ".completion_status', 'completed');");
#	JavaScript.eval("ScormProcessCommit();")
	var done = true
	for i in range(0, complete.size() - 1):
		if !complete[i]:
			done = false
	if done:
		JavaScript.eval("ScormProcessSetValue('cmi.success_status', 'passed');");
		JavaScript.eval("ScormProcessSetValue('cmi.completion_status', 'completed');");

func ScormLoad():
	JavaScript.eval("alert(ScormProcessGetValue('cmi.objectives._count'));")
	for i in range(0, complete.size() - 1):
		var id = JavaScript.eval("ScormProcessGetValue('cmi.objectives." + String(i) + ".id');")
		if id:
			var status = JavaScript.eval("ScormProcessGetValue('cmi.objectives." + String(i) + ".completion_status');")
			if status == "completed":
				complete[i] = true
				get_parent().get_node("Building" + missions[i]["building"] + "_Good").show()
				get_parent().get_node("Building" + missions[i]["building"] + "_Bad").hide()
		else:
			JavaScript.eval("ScormProcessSetValue('cmi.objectives." + String(i) + ".id', '" + String(i) + "');")
	JavaScript.eval("alert(ScormProcessGetValue('cmi.objectives._count'));")
	JavaScript.eval("ScormProcessCommit();")

func ScormLoad2():
	JavaScript.eval("alert(ScormProcessGetValue('cmi.objectives._count'));")
	var x = 0
	var num = JavaScript.eval("ScormProcessGetValue('cmi.objectives._count');")
	if typeof(num) == TYPE_STRING:
		num = int(num)
	if typeof(num) == TYPE_REAL:
		num = int(num)
	if typeof(num) == TYPE_NIL:
		num = 0
	#JavaScript.eval("alert('" + String(num) + ", " + String(complete.size()) + ";'")
	x = 1
	if num < complete.size():
		for i in range(num, complete.size() - 1):
			JavaScript.eval("ScormProcessSetValue('cmi.objectives." + String(i) + ".id', '" + String(i) + "');")
			#JavaScript.eval("ScormProcessSetValue('cmi.objectives." + String(i) + ".completion_status', 'incomplete');")
	#JavaScript.eval("alert('" + String(num) + ", " + String(complete.size()) + ";'")
	x = 2
	if num > 0:
		for i in range(0, num - 1):
			var status = JavaScript.eval("ScormProcessGetValue('cmi.objectives." + String(i) + ".completion_status');")
			if status == "completed":
				complete[i] = true
				get_parent().get_node("Building" + missions[i]["building"] + "_Good").show()
				get_parent().get_node("Building" + missions[i]["building"] + "_Bad").hide()
	JavaScript.eval("alert(ScormProcessGetValue('cmi.objectives._count'));")
