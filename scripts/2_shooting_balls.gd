extends Node2D

var bullet_scene = preload("res://scenes/minigames/shooting_balls/bullet.tscn")

@onready var hud = $Hud as Hud
@onready var cannon = $Cannon
@onready var targets = $Targets
@onready var target_count = targets.get_child_count()

var selected_ammo : int

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.digit_pressed.connect(hud_button_press)
	setup_layout()
	connect_to_targets()
	mark_selected_ammo_button(selected_ammo)

# setup layout based on travelling direction
func setup_layout():
	if GM.travelling_back:
		hud.current_layout = hud.Layout.ZERO
	else:
		hud.current_layout = hud.Layout.NOT_SOLVABLE
	var layout_arr = hud.layouts.get(hud.current_layout)
	selected_ammo = layout_arr[len(layout_arr)-1]
	hud.setup(layout_arr) # refresh Hud to take changes into account
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_cannon_direction()

# change new buttons normal appearance as the hover one and change old buttons back
func mark_selected_ammo_button(new_digit : int):
	var old_butt = hud.buttons.get_child(selected_ammo) as TextureButton
	old_butt.texture_normal = load(hud.NORMAL_ICON + str(selected_ammo) + ".png")
	
	var new_butt = hud.buttons.get_child(new_digit) as TextureButton
	new_butt.texture_normal = load(hud.HOVER_ICON + str(new_digit) + ".png")	


func hud_button_press(new_digit : int):
	print("button pressed")
	mark_selected_ammo_button(new_digit) 
	selected_ammo = new_digit # select new ammo

# connect to targets destroyed signals
func connect_to_targets():
	for target in targets.get_children():
		target.i_am_destroyed.connect(check_targets_destroyed)	

# sends signal to complete level if all targets destroyed
func check_targets_destroyed():
	target_count -= 1
	if target_count == 0:
		GM.level_completed.emit()

func set_cannon_direction():
	var mouse_pos = get_global_mouse_position()
	cannon.look_at(mouse_pos)

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot(selected_ammo)

# shoots the specified digit, the digit value controls the weight of the bullet
func shoot(digit_to_shoot : float):
	var bullet : Bullet = bullet_scene.instantiate() as Bullet
	bullet.position = cannon.position
	var mouse_pos : Vector2 = get_global_mouse_position()
	bullet.direction = (mouse_pos - bullet.position).normalized()
	bullet.digit = digit_to_shoot
	bullet.rotation
	get_tree().current_scene.add_child(bullet)
