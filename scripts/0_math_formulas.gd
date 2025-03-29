extends Node2D

@onready var BLACKBOARD_LABEL : Label = $BlackboardLabel

var travelling_back : bool

enum Operation {ADD, SUB, MULT, DIV}

var num1s : Array[int] =     [1,             4,             3,              1]
var ops : Array[Operation] = [Operation.ADD, Operation.DIV, Operation.MULT, Operation.SUB]
var num2s : Array[int] =     [2,             2,             3,              1]
var results : Array[int] =   [3,             2,             9,              10] # 10 means not solvable

var num1s_back : Array[int] =     [1,             0,             9,              0]
var ops_back : Array[Operation] = [Operation.SUB, Operation.ADD, Operation.MULT, Operation.DIV]
var num2s_back : Array[int] =     [1,             0,             0,              0]
var results_back : Array[int] =   [0,             0,             0,              69] # 69 means it will all explode

var current_problem : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	travelling_back = GM.travelling_back
	
	if(travelling_back):
		$Hud.current_layout = $Hud.Layout.ZERO
		$Hud.setup($Hud.layouts[$Hud.current_layout])
		
	$Hud.digit_pressed.connect(evaluate_button_press)
	
	show_problem(BLACKBOARD_LABEL, current_problem)
	
func show_problem(label: Label, i : int):
	if(travelling_back):
		label.text = str(num1s_back[i]) + " " + operation_to_string(ops_back[i]) + " " + str(num2s_back[i]) + " = ?"
	else:
		label.text = str(num1s[i]) + " " + operation_to_string(ops[i]) + " " + str(num2s[i]) + " = ?"
	
func operation_to_string(op : Operation) -> String:
	match op:
		Operation.ADD:
			return "+"
		Operation.SUB:
			return "-"
		Operation.MULT:
			return "*"
		Operation.DIV:
			return "/"
		_:
			return "NECO SPATNEHO, CO ROZHODNE NENI DOBRE"

func evaluate_button_press(input : int):
	if travelling_back && current_problem == results_back.size() - 1:
		# TODO: create ending
		print("EXPLODUJ")
		
	var result : int
	if travelling_back:
		result = results_back[current_problem]
	else:
		result = results[current_problem]
		
	if input == result:
		current_problem += 1
		if current_problem >= results.size():
			GM.level_completed.emit()
		else:
			show_problem(BLACKBOARD_LABEL, current_problem)
