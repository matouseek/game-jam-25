extends Node2D

@onready var FORWARD_PROBLEMS : Node = $Forward/Problems
@onready var FORWARD_RESULTS : Node = $Forward/Results

@onready var BACK_PROBLEMS : Node = $Back/Problems
@onready var BACK_RESULTS : Node = $Back/Results

const BOARD_SOUND_PATH : String = "res://assets/sfx/board.mp3"

const FADE_TIME = 2

var travelling_back : bool

var results : Array[int] = [3, 2, 9, 10] # 10 means not solvable

var results_back : Array[int] = [0, 0, 0, 69] # 69 means it will all explode

var current_problem : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	travelling_back = GM.travelling_back
	
	if(travelling_back):
		$Hud.current_layout = $Hud.Layout.ZERO
		$Hud.setup($Hud.layouts[$Hud.current_layout])
		
	$Hud.digit_pressed.connect(evaluate_button_press)
	
	show_problem(current_problem)
	
func show_problem(i : int):
	var tween : Tween
	GM.play_sfx(BOARD_SOUND_PATH)
	if(travelling_back):
		tween = get_tree().create_tween()
		tween.tween_property(BACK_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	else:
		tween = get_tree().create_tween()
		tween.tween_property(FORWARD_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	await tween.finished
		
func show_result(i : int):
	var tween : Tween
	GM.play_sfx(BOARD_SOUND_PATH)
	if(travelling_back):
		tween = get_tree().create_tween()
		tween.tween_property(BACK_RESULTS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	else:
		tween = get_tree().create_tween()
		tween.tween_property(FORWARD_RESULTS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	
	await tween.finished
		
func hide_all(i : int):
	var tween : Tween
	if travelling_back:
		tween = get_tree().create_tween().set_parallel()
		tween.tween_property(BACK_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 0, FADE_TIME)
		tween.tween_property(BACK_RESULTS.get_child(i) as Sprite2D, "modulate:a", 0, FADE_TIME)
	else:
		tween = get_tree().create_tween().set_parallel()
		tween.tween_property(FORWARD_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 0, FADE_TIME)
		tween.tween_property(FORWARD_RESULTS.get_child(i) as Sprite2D, "modulate:a", 0, FADE_TIME)
		tween.set_parallel()
		
	await tween.finished
	
		

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
			await show_result(current_problem - 1)
			await hide_all(current_problem - 1)
			await show_problem(current_problem)
