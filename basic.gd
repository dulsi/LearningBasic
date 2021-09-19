extends TextEdit

var InputTest = load("res://inputtest.gd")

var running = 0
signal output_screen(t)
signal clear_screen

var initial_code

#input
var input
var test_data = [
	{ "input" : [["4"], ["-12"], ["100"], ["-9"], ["-100"], ["23"], ["-12"], ["45"], ["56"], ["111"], ["-55"], ["-100"], ["-18"], ["-10"], ["1024"], ["-999"], ["1"], ["0"]], "output" : "4 100\n23 45\n56 111\n1024 1\n"}
]
var current_test = 0

#tokenizer
var program = []
var ptr = 0
var nextptr = 0
var current_token = TOKENIZER_ERROR
var MAX_NUMLEN = 6
var keywords = [
  ["let", TOKENIZER_LET],
  ["print", TOKENIZER_PRINT],
  ["if", TOKENIZER_IF],
  ["then", TOKENIZER_THEN],
  ["else", TOKENIZER_ELSE],
  ["for", TOKENIZER_FOR],
  ["to", TOKENIZER_TO],
  ["next", TOKENIZER_NEXT],
  ["goto", TOKENIZER_GOTO],
  ["gosub", TOKENIZER_GOSUB],
  ["return", TOKENIZER_RETURN],
  ["call", TOKENIZER_CALL],
  ["rem", TOKENIZER_REM],
  ["peek", TOKENIZER_PEEK],
  ["poke", TOKENIZER_POKE],
  ["input", TOKENIZER_INPUT],
  ["end", TOKENIZER_END]
]

enum {TOKENIZER_ERROR,
  TOKENIZER_ENDOFINPUT,
  TOKENIZER_NUMBER,
  TOKENIZER_STRING,
  TOKENIZER_VARIABLE,
  TOKENIZER_LET,
  TOKENIZER_PRINT,
  TOKENIZER_IF,
  TOKENIZER_THEN,
  TOKENIZER_ELSE,
  TOKENIZER_FOR,
  TOKENIZER_TO,
  TOKENIZER_NEXT,
  TOKENIZER_GOTO,
  TOKENIZER_GOSUB,
  TOKENIZER_RETURN,
  TOKENIZER_CALL,
  TOKENIZER_REM,
  TOKENIZER_PEEK,
  TOKENIZER_POKE,
  TOKENIZER_INPUT,
  TOKENIZER_END,
  TOKENIZER_COMMA,
  TOKENIZER_SEMICOLON,
  TOKENIZER_PLUS,
  TOKENIZER_MINUS,
  TOKENIZER_AND,
  TOKENIZER_OR,
  TOKENIZER_ASTR,
  TOKENIZER_SLASH,
  TOKENIZER_MOD,
  TOKENIZER_HASH,
  TOKENIZER_LEFTPAREN,
  TOKENIZER_RIGHTPAREN,
  TOKENIZER_LT,
  TOKENIZER_GT,
  TOKENIZER_EQ,
  TOKENIZER_NE,
  TOKENIZER_LTE,
  TOKENIZER_GTE,
  TOKENIZER_FUNCTION,
  TOKENIZER_CR}
#ubasic
var ended = 0
var line_index = []
var variables = {}
var gosub_stack = []
var for_stack = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ubasic_init(pgtext, inputsource):
	variables = {}
	input = inputsource
	input.first_input()
	index_free()
	tokenizer_init(pgtext)
	ended = 0

func accept(t):
	if t != tokenizer_token():
		print("Error:" + String(t) + "!=" + String(tokenizer_token()))
	tokenizer_next()

func acceptend():
	if tokenizer_token() == TOKENIZER_CR:
		tokenizer_next()
		return 1
	elif tokenizer_token() == TOKENIZER_ELSE || tokenizer_token() == TOKENIZER_ENDOFINPUT:
		return 1
	else:
		return 0

func function():
	var nm = tokenizer_variable_name()
	accept(TOKENIZER_FUNCTION)
	accept(TOKENIZER_LEFTPAREN)
	var arg = []
	while tokenizer_token() != TOKENIZER_RIGHTPAREN:
		arg.push_back(expr())
		if tokenizer_token() == TOKENIZER_COMMA:
			accept(TOKENIZER_COMMA)
		elif tokenizer_token() != TOKENIZER_RIGHTPAREN:
			emit_signal("output_screen", "Runtime Error: Function arguments incorrect\n")
			_on_Stop_pressed()
			return 0
	accept(TOKENIZER_RIGHTPAREN)
	match nm:
		"len":
			return arg[0].to_ascii().size()
		"chr$":
			return PoolByteArray([arg[0]]).get_string_from_ascii()
		"asc":
			return arg[0].to_ascii()[0]
		"mid$":
			var s = arg[0].to_ascii()
			return s.subarray(arg[1] - 1, arg[1] + arg[2] - 2).get_string_from_ascii()

func varfactor():
	var r = ubasic_get_variable(tokenizer_variable_name())
	accept(TOKENIZER_VARIABLE)
	return r

func factor():
	var r = 0
	match tokenizer_token():
		TOKENIZER_NUMBER:
			r = tokenizer_num()
			accept(TOKENIZER_NUMBER)
		TOKENIZER_STRING:
			r = tokenizer_string()
			accept(TOKENIZER_STRING)
		TOKENIZER_LEFTPAREN:
			accept(TOKENIZER_LEFTPAREN)
			r = expr()
			accept(TOKENIZER_RIGHTPAREN)
		TOKENIZER_VARIABLE:
			r = varfactor()
		TOKENIZER_FUNCTION:
			r = function()
	return r

func term():
	var f1 = factor()
	var op = tokenizer_token()
	while op == TOKENIZER_ASTR || op == TOKENIZER_SLASH || op == TOKENIZER_MOD:
		tokenizer_next()
		var f2 = factor()
		if typeof(f1) == TYPE_STRING || typeof(f2) == TYPE_STRING:
			var op_string = "*"
			if op == TOKENIZER_SLASH:
				op_string = "/"
			elif op == TOKENIZER_MOD:
				op_string = "%"
			emit_signal("output_screen", "Runtime Error: String cannot perform this operation: " + String(f1) + op_string + String(f2) + "\n")
			_on_Stop_pressed()
			break
		match op:
			TOKENIZER_ASTR:
				f1 = f1 * f2
			TOKENIZER_SLASH:
				f1 = f1 / f2
			TOKENIZER_MOD:
				f1 = f1 % f2
		op = tokenizer_token()
	return f1

func expr():
	var t1 = term()
	var op = tokenizer_token()
	while op == TOKENIZER_PLUS || op == TOKENIZER_MINUS || op == TOKENIZER_AND || op == TOKENIZER_OR:
		tokenizer_next()
		var t2 = term()
		if (typeof(t1) == TYPE_STRING || typeof(t2) == TYPE_STRING) && op != TOKENIZER_PLUS:
			var op_string = "-"
			if op == TOKENIZER_AND:
				op_string = "&"
			elif op == TOKENIZER_OR:
				op_string = "|"
			emit_signal("output_screen", "Runtime Error: String cannot perform this operation: " + String(t1) + op_string + String(t2) + "\n")
			_on_Stop_pressed()
			break
		if typeof(t1) != typeof(t2) && op == TOKENIZER_PLUS:
			emit_signal("output_screen", "Runtime Error: Variables of different type cannot perform this operation: " + String(t1) + "+" + String(t2) + "\n")
			_on_Stop_pressed()
			break
		match op:
			TOKENIZER_PLUS:
				t1 = t1 + t2
			TOKENIZER_MINUS:
				t1 = t1 - t2
			TOKENIZER_AND:
				t1 = t1 & t2
			TOKENIZER_OR:
				t1 = t1 | t2
		op = tokenizer_token()
	return t1

func relation():
	var r1 = expr()
	var op = tokenizer_token()
	while op == TOKENIZER_LT || op == TOKENIZER_GT || op == TOKENIZER_EQ || op == TOKENIZER_LTE || op == TOKENIZER_GTE || op == TOKENIZER_NE:
		tokenizer_next()
		var r2 = expr()
		if (typeof(r1) == TYPE_STRING || typeof(r2) == TYPE_STRING) && (op != TOKENIZER_EQ && op != TOKENIZER_NE):
			var op_string = "<"
			if op == TOKENIZER_GT:
				op_string = ">"
			elif op == TOKENIZER_GTE:
				op_string = ">="
			elif op == TOKENIZER_LTE:
				op_string = "<="
			emit_signal("output_screen", "Runtime Error: String cannot perform this operation: " + String(r1) + op_string + String(r2) + "\n")
			_on_Stop_pressed()
			break
		if typeof(r1) != typeof(r2) && (op == TOKENIZER_EQ || op == TOKENIZER_NE):
			var op_string = "="
			if op == TOKENIZER_NE:
				op_string = "<>"
			emit_signal("output_screen", "Runtime Error: Variables of different type cannot perform this operation: " + String(r1) + op_string + String(r2) + "\n")
			_on_Stop_pressed()
			break
		match op:
			TOKENIZER_LT:
				r1 = r1 < r2
			TOKENIZER_GT:
				r1 = r1 > r2
			TOKENIZER_LTE:
				r1 = r1 <= r2
			TOKENIZER_GTE:
				r1 = r1 >= r2
			TOKENIZER_EQ:
				r1 = r1 == r2
			TOKENIZER_NE:
				r1 = r1 != r2
		op = tokenizer_token()
	return r1
	

func index_free():
	line_index = []

func index_find(linenum):
	for i in line_index:
		if i[0] == linenum:
			return i[1]
	return -1

func index_add(linenum, sourcepos):
	if -1 != index_find(linenum):
		return
	line_index.push_back([linenum, sourcepos])

func jump_linenum_slow(linenum):
	tokenizer_goto(0)
	while tokenizer_num() != linenum:
		while nextptr != program.size() && program[nextptr] != ord('\n'):
			nextptr += 1
		if nextptr != program.size():
			nextptr += 1
		tokenizer_next()
		while tokenizer_token() == TOKENIZER_CR && !tokenizer_finished():
			tokenizer_next()
		if !tokenizer_finished():
			index_add(tokenizer_num(), tokenizer_pos())
		else:
			emit_signal("output_screen", "Runtime Error: Line " + String(linenum) + " not found\n")
			_on_Stop_pressed()
			break

func jump_linenum(linenum):
	var pos = index_find(linenum)
	if pos != -1:
		tokenizer_goto(pos)
	else:
		jump_linenum_slow(linenum)

func goto_statement():
	accept(TOKENIZER_GOTO)
	jump_linenum(tokenizer_num())

func print_statement():
	accept(TOKENIZER_PRINT)
	while !acceptend():
		if tokenizer_token() == TOKENIZER_COMMA:
			emit_signal("output_screen", " ")
			tokenizer_next();
		elif tokenizer_token() == TOKENIZER_SEMICOLON:
			tokenizer_next();
		elif tokenizer_token() == TOKENIZER_VARIABLE || tokenizer_token() == TOKENIZER_NUMBER || tokenizer_token() == TOKENIZER_LEFTPAREN || tokenizer_token() == TOKENIZER_STRING || tokenizer_token() == TOKENIZER_FUNCTION:
			var a = expr()
			emit_signal("output_screen", a)
		else:
			break
	emit_signal("output_screen", "\n")

func if_statement():
	accept(TOKENIZER_IF)
	var r = relation()
	accept(TOKENIZER_THEN)
	if (r):
		statement()
		if tokenizer_token() == TOKENIZER_ELSE:
			accept(TOKENIZER_ELSE)
			while !acceptend():
				tokenizer_next()
	else:
		while !acceptend():
			tokenizer_next()
		if tokenizer_token() == TOKENIZER_ELSE:
			accept(TOKENIZER_ELSE)
			statement()

func let_statement():
	var nm = tokenizer_variable_name()
	accept(TOKENIZER_VARIABLE)
	accept(TOKENIZER_EQ)
	ubasic_set_variable(nm, expr())
	if 1 != acceptend():
		print("Error: " + String(tokenizer_token()))

func gosub_statement():
	accept(TOKENIZER_GOSUB)
	var linenum = tokenizer_num()
	accept(TOKENIZER_NUMBER)
	if 1 != acceptend():
		print("Error")
	gosub_stack.push_back(tokenizer_num())
	index_add(tokenizer_num(), tokenizer_pos())
	jump_linenum(linenum)

func return_statement():
	accept(TOKENIZER_RETURN)
	if gosub_stack.size() == 0:
		print("Error")
	else:
		jump_linenum(gosub_stack.pop_back())

func next_statement():
	accept(TOKENIZER_NEXT)
	var for_variable = tokenizer_variable_name()
	accept(TOKENIZER_VARIABLE)
	var for_values = for_stack.get(for_variable)
	if for_values == null:
		emit_signal("output_screen", "Runtime Error: No for loop index named: " + for_variable + "\n")
		_on_Stop_pressed()
	else:
		ubasic_set_variable(for_variable, ubasic_get_variable(for_variable) + 1)
		if ubasic_get_variable(for_variable) <= for_values[0]:
			jump_linenum(for_values[1])
		else:
			if ubasic_get_variable(for_variable) > for_values[0] + 1:
				emit_signal("output_screen", "Runtime Error: For loop index already at max value: " + for_variable + "\n")
				_on_Stop_pressed()
			acceptend()

func for_statement():
	accept(TOKENIZER_FOR)
	var for_variable = tokenizer_variable_name()
	accept(TOKENIZER_VARIABLE)
	accept(TOKENIZER_EQ)
	ubasic_set_variable(for_variable, expr())
	accept(TOKENIZER_TO)
	var to = expr()
	if 1 != acceptend():
		print("Error")
	for_stack[for_variable] = [to, tokenizer_num()]


func input_statement():
	accept(TOKENIZER_INPUT)
	var out = "?"
	if tokenizer_token() == TOKENIZER_STRING:
		out = tokenizer_string() + "?"
		accept(TOKENIZER_STRING)
		accept(TOKENIZER_SEMICOLON)
	while tokenizer_token() == TOKENIZER_VARIABLE:
		var val = input.get_input()
		var nm = tokenizer_variable_name()
		out = out + val;
		if !nm.ends_with("$"):
			val = int(val)
		ubasic_set_variable(tokenizer_variable_name(), val)
		accept(TOKENIZER_VARIABLE)
		if tokenizer_token() == TOKENIZER_COMMA:
			accept(TOKENIZER_COMMA)
			out = out + " "
		else:
			break
	input.finish_line()
	if running == 1:
		emit_signal("output_screen", out + "\n")
	acceptend()

func end_statement():
	accept(TOKENIZER_END)
	ended = 1

func statement():
	var t = tokenizer_token()
	match t:
		TOKENIZER_PRINT:
			print_statement()
		TOKENIZER_IF:
			if_statement()
		TOKENIZER_GOTO:
			goto_statement()
		TOKENIZER_GOSUB:
			gosub_statement()
		TOKENIZER_RETURN:
			return_statement()
		TOKENIZER_FOR:
			for_statement()
		TOKENIZER_NEXT:
			next_statement()
		TOKENIZER_INPUT:
			input_statement()
		TOKENIZER_END:
			end_statement()
		TOKENIZER_LET:
			accept(TOKENIZER_LET)
			let_statement()
		TOKENIZER_VARIABLE:
			let_statement()
		TOKENIZER_REM:
			while nextptr != program.size() && program[nextptr] != ord('\n'):
				nextptr += 1
			if nextptr != program.size():
				nextptr += 1
			tokenizer_next()
		_:
			print("Error")

func line_statement():
	while tokenizer_token() == TOKENIZER_CR && !tokenizer_finished():
		tokenizer_next()
	if !tokenizer_finished():
		index_add(tokenizer_num(), tokenizer_pos())
		accept(TOKENIZER_NUMBER)
		statement()

func ubasic_run():
	if tokenizer_finished():
		return
	line_statement()

func ubasic_finished():
	return ended || tokenizer_finished()

func ubasic_set_variable(nm, value):
	variables[nm] = value

func ubasic_get_variable(nm):
	return variables.get(nm, 0)

func singlechar():
	if program[ptr] == ord('\n'):
		return TOKENIZER_CR
	elif program[ptr] == ord(','):
		return TOKENIZER_COMMA
	elif program[ptr] == ord(';'):
		return TOKENIZER_SEMICOLON
	elif program[ptr] == ord('+'):
		return TOKENIZER_PLUS
	elif program[ptr] == ord('-'):
		return TOKENIZER_MINUS
	elif program[ptr] == ord('&'):
		return TOKENIZER_AND
	elif program[ptr] == ord('|'):
		return TOKENIZER_OR
	elif program[ptr] == ord('*'):
		return TOKENIZER_ASTR
	elif program[ptr] == ord('/'):
		return TOKENIZER_SLASH
	elif program[ptr] == ord('%'):
		return TOKENIZER_MOD
	elif program[ptr] == ord('('):
		return TOKENIZER_LEFTPAREN
	elif program[ptr] == ord('#'):
		return TOKENIZER_HASH
	elif program[ptr] == ord(')'):
		return TOKENIZER_RIGHTPAREN
	elif program[ptr] == ord('<'):
		return TOKENIZER_LT
	elif program[ptr] == ord('>'):
		return TOKENIZER_GT
	elif program[ptr] == ord('='):
		return TOKENIZER_EQ
	return 0

func is_alpha(c):
	if c >= ord('a') && c <= ord('z'):
		return true
	if c >= ord('A') && c <= ord('Z'):
		return true
	return false

func get_next_token():
	if ptr == program.size():
		return TOKENIZER_ENDOFINPUT
	if program[ptr] >= ord('0') && program[ptr] <= ord('9'):
		for i in range(1, MAX_NUMLEN):
			if ptr+i == program.size() || !(program[ptr + i] >= ord('0') && program[ptr + i] <= ord('9')):
				nextptr = ptr + i
				return TOKENIZER_NUMBER
		return TOKENIZER_ERROR
	elif singlechar():
		var t1 = singlechar()
		nextptr = ptr + 1
		if t1 == TOKENIZER_LT:
			ptr = ptr + 1
			var t2 = singlechar()
			if t2 == TOKENIZER_GT:
				t1 = TOKENIZER_NE
				nextptr = ptr + 1
			elif t2 == TOKENIZER_EQ:
				t1 = TOKENIZER_LTE
				nextptr = ptr + 1
			else:
				ptr = ptr - 1
		if t1 == TOKENIZER_GT:
			ptr = ptr + 1
			var t2 = singlechar()
			if t2 == TOKENIZER_EQ:
				t1 = TOKENIZER_GTE
				nextptr = ptr + 1
			else:
				ptr = ptr - 1
		return t1
	elif program[ptr] == ord('"'):
		nextptr = ptr + 1
		while nextptr != program.size() && program[nextptr] != ord('"'):
			nextptr += 1
		if nextptr == program.size():
			return TOKENIZER_ERROR
		nextptr += 1
		return TOKENIZER_STRING
	else:
		var alpha = 0
		while ptr + alpha < program.size() && is_alpha(program[ptr + alpha]):
			if program[ptr + alpha] >= ord('A') && program[ptr + alpha] <= ord('Z'):
				program[ptr + alpha] = program[ptr + alpha] - ord('A') + ord('a')
			alpha = alpha + 1
		for kt in keywords:
			var tmp = kt[0].to_utf8()
			var good = true
			for i in range(0, tmp.size()):
				if ptr + i == program.size() || program[ptr + i] != tmp[i]:
					good = false
					break
			if good:
				nextptr = ptr + tmp.size()
				return kt[1]
	if program[ptr] >= ord('a') && program[ptr] <= ord('z'):
		nextptr = ptr + 1
		while nextptr < program.size() && program[nextptr] >= ord('a') && program[nextptr] <= ord('z'):
			nextptr = nextptr + 1
		if nextptr < program.size() && program[nextptr] == ord('$'):
			nextptr = nextptr + 1
		if nextptr < program.size() && program[nextptr] == ord('('):
			return TOKENIZER_FUNCTION
		return TOKENIZER_VARIABLE
	return TOKENIZER_ERROR

func tokenizer_goto(sourcepos):
	ptr = sourcepos
	current_token = get_next_token()

func tokenizer_init(pgtext):
	program = pgtext.to_utf8()
	ptr = 0
	nextptr = 0
	current_token = get_next_token()

func tokenizer_token():
	return current_token

func tokenizer_next():
	if tokenizer_finished():
		return
	ptr = nextptr
	while ptr != program.size() && program[ptr] == ord(' '):
		ptr += 1
	current_token = get_next_token()

func tokenizer_num():
	var num = 0
	for i in range(0, MAX_NUMLEN):
		if ptr+i == program.size():
			break
		if program[ptr + i] >= ord('0') && program[ptr + i] <= ord('9'):
			num = num * 10 + (program[ptr + i] - ord('0'))
		else:
			break
	return num

func tokenizer_string():
	return program.subarray(ptr + 1, nextptr - 2).get_string_from_utf8()

func tokenizer_finished():
	return ptr == program.size() || current_token == TOKENIZER_ENDOFINPUT

func tokenizer_variable_name():
	return program.subarray(ptr, nextptr - 1).get_string_from_utf8()

func tokenizer_pos():
	return ptr

func find_line():
	if ptr == 0:
		return 0
	if ptr == program.size():
		return 0
	var line = 0
	for i in range(ptr):
		if program[i] == ord('\n'):
			line = line + 1
	return line

func _on_TextEdit_text_changed():
	running = 0
	deselect()


func _on_Run_pressed():
	_on_Step_pressed()
	$NextStep.start()


func _on_Step_pressed():
	if running == 0:
		emit_signal("clear_screen")
		ubasic_init(text, get_parent().get_node("RightPanel").get_node("WorkTab").get_node("InputScreen"))
		running = 1
	if !ubasic_finished():
		ubasic_run()
	if ubasic_finished():
		if running == 2:
			next_test()
		else:
			_on_Stop_pressed()
	elif running > 0:
		var line = find_line()
		select(line, 0, line, 1000)


func _on_NextStep_timeout():
	if !ubasic_finished():
		ubasic_run()
	if ubasic_finished():
		if running == 2:
			next_test()
		else:
			_on_Stop_pressed()
	elif running > 0:
		var line = find_line()
		select(line, 0, line, 1000)


func _on_Stop_pressed():
	running = 0
	deselect()
	$NextStep.stop()


func _on_Test_pressed():
	current_test = 0
	var test_input = InputTest.new()
	test_input.data = test_data[current_test]["input"]
	emit_signal("clear_screen")
	var test_text = text
	if test_data[current_test].has("replace"):
		test_text = test_text.replace(test_data[current_test]["match"], test_data[current_test]["replace"])
	ubasic_init(test_text, test_input)
	running = 2
	_on_Run_pressed()

func next_test():
	if test_data[current_test]["output"] != get_parent().get_node("RightPanel").get_node("WorkTab").get_node("OutputScreen").text:
		_on_Stop_pressed()
		emit_signal("clear_screen")
		print("Test Failed")
	else:
		emit_signal("clear_screen")
		current_test = current_test + 1
		if current_test < test_data.size():
			var test_input = InputTest.new()
			test_input.data = test_data[current_test]["input"]
			var test_text = text
			if test_data[current_test].has("replace"):
				test_text = test_text.replace(test_data[current_test]["match"], test_data[current_test]["replace"])
			ubasic_init(test_text, test_input)
			running = 2
		else:
			_on_Stop_pressed()
			get_parent().set_complete()
