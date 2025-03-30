extends Node2D

var travelling_back: bool

const MAX_STATE: int = 3

@onready var STATE: int = -1

@onready var CHANGE_PASSWORD : Label = $Control/ChangePasswordLabel
@onready var PASSWD_INSTRUCT_2 : Label = $Control/PasswordInstructionsLabel2

const TEXT_TWEEN_DURATION : float = 1
const TIME_BEFORE_TWEEN : float = 1

var PASSWD_VALUE : String = "9999999999"
var shake : bool = false
const cam_pos = Vector2(960, 540)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/PasswordLineEdit.text_submitted.connect(change_global_state)
	
	travelling_back = GM.travelling_back
	
	if travelling_back:
		rewrite_text_for_travelling_back()
	
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
			if (travelling_back && text == PASSWD_VALUE):
				end_minigame()
				return
			var tween := await tween_label($Control.get_child(state) as Label)
			await tween.finished
			tween_label(PASSWD_INSTRUCT_2)
		2:
			if (text != PASSWD_VALUE):
				STATE -= 1
				return
			shaking()
			end_minigame()
		_:
			print(GM.STANDARD_ERROR_MESSAGE + " se stavem " + str(state))

func end_minigame() -> void:
	for i in range(MAX_STATE):
		($Control.get_child(i) as Label).visible = false
			
	CHANGE_PASSWORD.visible = false
	PASSWD_INSTRUCT_2.visible = false
			
	var l : Label = $Control.get_child(2) as Label
	l.visible = true
			
	var timer := get_tree().create_timer(TIME_BEFORE_TWEEN)
			
	await timer.timeout
	GM.level_completed.emit()

func rewrite_text_for_travelling_back():
	CHANGE_PASSWORD.text = "You need to change your ships password"
	$Control/PasswordLineEdit.placeholder_text = "new password"
	
	$Control/RecommendedPasswordLabel.text = "The recommended password is: zero"
	
	$Control/PasswordWeakLabel.text = "Password Strength: 10/10"
	$Control/PasswordWeakLabel.modulate.r = 0
	$Control/PasswordWeakLabel.modulate.g = 1
	
	PASSWD_INSTRUCT_2.text = "- The password must begin with your credit card number
	- This has to be followed by your credit card expiry date
	- The password must end with the three numbers on the back of your credit card
	- Make sure you are connected to the internet before submitting!"
	
	PASSWD_VALUE = "zero"
	
func shake_screen():
	var order = 0.3
	const max_shake = 5
	const max_roll = 0.5
	$Cam.rotation = max_roll * order * randfn(-1, 1)
	$Cam.position = Vector2(cam_pos.x+randfn(-1,1.2)*max_shake*order, cam_pos.y+randfn(-1,1.2)*max_shake*order)
	
func shaking():
	shake = true
	var tt = get_tree().create_timer(0.3)
	await tt.timeout
	shake = false
	
func _process(delta: float) -> void:
	if shake: shake_screen()
	else: $Cam.position = cam_pos
