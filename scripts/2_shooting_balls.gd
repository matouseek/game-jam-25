extends Node2D

var bullet_scene = preload("res://scenes/minigames/bullet.tscn")

var loaded_digit : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(func() : GM.level_completed.emit())
	$Hud.digit_pressed.connect(func(digit : int) : loaded_digit = digit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		print("loaded digit" + str(loaded_digit))
		shoot(loaded_digit)

func shoot(digit_to_shoot : float):
	var bullet : Bullet = bullet_scene.instantiate() as Bullet
	bullet.position = $ShotOrigin.position
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.direction = (mouse_pos - bullet.position).normalized()
	bullet.digit = digit_to_shoot 
	get_tree().current_scene.add_child(bullet)
