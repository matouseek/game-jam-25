extends Node2D

@onready var BLACKBOARD_LABEL : Label = $BlackboardLabel

enum Operation {ADD, SUB, MULT, DIV}

var num1s : Array[int] =     [1,             4,             3,              1]
var ops : Array[Operation] = [Operation.ADD, Operation.DIV, Operation.MULT, Operation.SUB]
var num2s : Array[int] =     [2,             2,             3,              1]
var results : Array[int] =   [3,             2,             9,              10] # 10 means not solvable

var current_problem : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hud.digit_pressed.connect(evaluate_button_press)
	
	show_problem(BLACKBOARD_LABEL, current_problem)
	
func show_problem(label: Label, i : int):
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
	if input == results[current_problem]:
		current_problem += 1
		if current_problem >= results.size():
			GM.level_completed.emit()
		else:
			show_problem(BLACKBOARD_LABEL, current_problem)
