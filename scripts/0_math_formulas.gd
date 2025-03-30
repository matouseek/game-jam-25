extends Node2D

@onready var FORWARD_PROBLEMS : Node = $Forward/Problems
@onready var FORWARD_RESULTS : Node = $Forward/Results

@onready var BACK_PROBLEMS : Node = $Back/Problems
@onready var BACK_RESULTS : Node = $Back/Results

const BOARD_SOUND_PATH : String = "res://assets/sfx/board.wav"
const WASHING_SOUND_PATH : String = "res://assets/sfx/washing_short.wav"
const CROWD_CHEER_SOUND_PATH : String = "res://assets/sfx/crowd_cheer.wav"
const CROWD_BOO_SOUND_PATH : String = "res://assets/sfx/crowd_boo.wav"
const CROWD_GASP_SOUND_PATH : String = "res://assets/sfx/crowd_gasp.wav"

const BOARD_EXPLANATION_DURATION : float = 5.0
const BOARD_FADE_TIME : float = 2.0

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
	GM.play_sfx(BOARD_SOUND_PATH,0)
	if(travelling_back):
		tween = get_tree().create_tween()
		tween.tween_property(BACK_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	else:
		tween = get_tree().create_tween()
		tween.tween_property(FORWARD_PROBLEMS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	await tween.finished
		
func show_result(i : int):
	var tween : Tween
	GM.play_sfx(BOARD_SOUND_PATH,0)
	disable_hud()
	if(travelling_back):
		tween = get_tree().create_tween()
		tween.tween_property(BACK_RESULTS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	else:
		tween = get_tree().create_tween()
		tween.tween_property(FORWARD_RESULTS.get_child(i) as Sprite2D, "modulate:a", 1, FADE_TIME)
	
	await tween.finished
		
func hide_all(i : int):
	var tween : Tween
	GM.play_sfx(WASHING_SOUND_PATH,0)
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
	enable_hud()
	
func play_cheer():
	var cheer_len : float = (load(CROWD_CHEER_SOUND_PATH) as AudioStream).get_length()
	GM.play_sfx(CROWD_CHEER_SOUND_PATH,0)
	await get_tree().create_timer(cheer_len).timeout
	
func play_boo():
	var boo_len : float = (load(CROWD_BOO_SOUND_PATH) as AudioStream).get_length()
	GM.play_sfx(CROWD_BOO_SOUND_PATH,0)
	await get_tree().create_timer(boo_len).timeout
	
func play_gasp():
	var gasp_len : float = (load(CROWD_GASP_SOUND_PATH) as AudioStream).get_length()
	GM.play_sfx(CROWD_GASP_SOUND_PATH,0)
	await get_tree().create_timer(gasp_len).timeout
		

func switch_board():
	$Blackboard.visible = false
	$BlackboardExpl.visible = true

func evaluate_button_press(input : int):
	# Button spam protection
	if current_problem >= results.size():
		return
	
	if travelling_back && current_problem == results_back.size() - 1:
		GM.fade_to_scene(GM.END_EXPLOSION_SCENE)
		
	var result : int
	if travelling_back:
		result = results_back[current_problem]
	else:
		result = results[current_problem]
		
	if input == result:
		current_problem += 1
		if current_problem >= results.size():
			await play_gasp()
			await GM.fade_to_function(switch_board,BOARD_FADE_TIME)
			await get_tree().create_timer(BOARD_EXPLANATION_DURATION).timeout
			GM.level_completed.emit()
		else:
			$Hud.visible = false
			await show_result(current_problem - 1)
			await play_cheer()
			await hide_all(current_problem - 1)
			await show_problem(current_problem)
			$Hud.visible = true
	else:
		await play_boo()

func disable_hud(): $Hud.process_mode = Node.PROCESS_MODE_DISABLED
	
func enable_hud(): $Hud.process_mode = Node.PROCESS_MODE_INHERIT
