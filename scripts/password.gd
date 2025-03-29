extends Node2D

const MAX_STATE: int = 3

@onready var STATE: int = -1

@onready var CHANGE_PASSWORD : Label = $Control/ChangePasswordLabel
@onready var PASSWD_INSTRUCT_2 : Label = $Control/PasswordInstructionsLabel2

const TEXT_TWEEN_DURATION : float = 1
const TIME_BEFORE_TWEEN : float = 1

const PASSWD_VALUE : String = "9999999999"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/PasswordLineEdit.text_submitted.connect(change_global_state)
	
	tween_label(CHANGE_PASSWORD)
	
func tween_label(label : Label) -> Tween:
	var timer = get_tree().create_timer(TIME_BEFORE_TWEEN)
	
	await timer.timeout
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1, TEXT_TWEEN_DURATION)
	
	return tween

func change_global_state(text: String) -> void:
	STATE += 1;
	uncover_label(STATE, text)

func uncover_label(state : int, text : String) -> void:
	match state:
		0:
			tween_label($Control.get_child(state) as Label)
		1:
			var tween := await tween_label($Control.get_child(state) as Label)
			await tween.finished
			tween_label(PASSWD_INSTRUCT_2)
		2:
			if (text != PASSWD_VALUE):
				STATE -= 1
				return
				
			for i in range(MAX_STATE):
				($Control.get_child(i) as Label).visible = false
			
			CHANGE_PASSWORD.visible = false
			PASSWD_INSTRUCT_2.visible = false
			
			var l : Label = $Control.get_child(state) as Label
			l.visible = true
			
			var timer := get_tree().create_timer(TIME_BEFORE_TWEEN)
			
			await timer.timeout
			
			end_minigame()
		_:
			print("Posralo se to nekde")

func end_minigame() -> void:
	print("Ending Minigame")
	GM.level_completed.emit()
