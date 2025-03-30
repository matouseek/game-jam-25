extends CanvasLayer

const PATH_TO_SCENES := "res://scenes/minigames/" 
const SCENES := ["password.tscn", "sacrifice.tscn","2shooting_balls.tscn"] ## contains filenames for scenes in sequential order

const ZEROLAND_SCENE = "res://scenes/zeroland_scenes/1docking.tscn"
const MATH_FORMULAS_SCENE = "res://scenes/minigames/0math_formulas.tscn"
const INTRO_SCENE := "res://scenes/cutscenes/intro.tscn"
const END_EXPLOSION_SCENE := "res://scenes/cutscenes/end_scene.tscn"

const MAP_SCENE_PATH := "res://scenes/map.tscn"

signal level_completed ## each minigame emits it when done
signal map_completed ## emits by map when player chose next minigame

signal mouse_entered_button ## to change cursor style
signal mouse_exited_button ## to change cursor style back

const WINDOW_WIDTH : int = 1920
const WINDOW_HEIGHT : int = 1080

var current_level : int = 0 # when -1 then we have come back again

# FADE STUFF
var FADE_TIME : float = 0.5
@onready var fade : ColorRect = $Fade

# MUSIC STUFF
@onready var sfx_parent = $SFXParent
#@onready var sfx2 : AudioStreamPlayer = $SFXParent/SFX2
#@onready var sfx3 : AudioStreamPlayer = $SFXParent/SFX3
@onready var music : AudioStreamPlayer = $Music

# MOUSE CURSOR
var arrow = load("res://assets/icon.svg")
var beam = load("res://assets/icon_red.svg")

# TRAVELLING BACK INDICATOR
var travelling_back : bool = false
var ship_back : bool = false

# MENU STUFF
var arachnofobia : bool = false
var is_playing : bool = false
@onready var menu = $Menu

# PHYSICS STUFF
const GRAVITY : float = 2000

const STANDARD_ERROR_MESSAGE = "Posralo se to nekde"

# Called when the node enters the scene tree for the first FADE_TIME.
func _ready() -> void:
	print(arachnofobia)
	#setup_cursor_hover_style() TODO: uncomment to set custom cursor
	$Fade.size = Vector2(WINDOW_WIDTH+80, WINDOW_HEIGHT)
	$Menu/UnclickableArea.size = Vector2(WINDOW_WIDTH+80, WINDOW_HEIGHT)
	level_completed.connect(switch_to_map)
	map_completed.connect(switch_to_level)
	music.volume_db = linear_to_db($Menu/MusicVolume.value)
	
	play_music('res://assets/music/skibidi.mp3')
	

func setup_sfx_parent():
	for sfx in sfx_parent.get_children():
		sfx.volume_db = linear_to_db($Menu/SFXVolume.value)

# sets the cursor to custom one
func setup_cursor_hover_style():
	Input.set_custom_mouse_cursor(arrow)
	mouse_entered_button.connect(func() : Input.set_custom_mouse_cursor(beam))
	mouse_exited_button.connect(func() : Input.set_custom_mouse_cursor(arrow))

# loads map scene and increases the current level count
func switch_to_map() -> void:
	if current_level >= 0:
		fade_to_scene(MAP_SCENE_PATH)
	if current_level == -1:
		fade_to_scene(MATH_FORMULAS_SCENE)
	else:
		# TODO: here implement game ending
		print(STANDARD_ERROR_MESSAGE + " na konci")

func switch_to_level() -> void:
	if current_level >= len(SCENES): # we have reached zeroland
		travelling_back = true
		fade_to_scene(ZEROLAND_SCENE)
	elif current_level < 0: # we have come back
		print(STANDARD_ERROR_MESSAGE)
	else:
		fade_to_scene(PATH_TO_SCENES + SCENES[current_level])
	if not travelling_back:
		current_level += 1
	else:
		current_level -= 1

# fades to scene
func fade_to_scene(scene : String):
	fade_to_function(func() : get_tree().change_scene_to_file(scene),FADE_TIME)

# this function can be used to fade to anything, not just scenes
func fade_to_function(function : Callable, fade_time : float):
	fade.visible = true
	var tween : Tween = get_tree().create_tween() # starts right after created
	tween.tween_property(fade,"color:a",1,fade_time)
	await tween.finished
	function.call()
	tween = get_tree().create_tween()
	tween.tween_property(fade,"color:a",0,fade_time)
	await tween.finished
	fade.visible = false

func menu_toggle() -> void:
	if (is_playing):
		get_tree().paused = !menu.visible
		menu.visible = !menu.visible
	else:
		MM.visible = menu.visible
		menu.visible = !menu.visible
	
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"): menu_toggle()
	

func _on_back_pressed() -> void:
	menu_toggle()


func _on_sfx_volume_value_changed(value: float) -> void:
	for sfx in sfx_parent.get_children():
		sfx.volume_db = linear_to_db(value)


func _on_music_volume_value_changed(value: float) -> void:
	music.volume_db = linear_to_db(value)

func play_music(filename: String):
	music.stream = load(filename) as AudioStream
	music.play()

func _on_music_finished() -> void:
	music.play()

func play_sfx(filename : String, index : int):
	var sfx = sfx_parent.get_child(index) as AudioStreamPlayer
	sfx.stream = (load(filename) as AudioStream)
	sfx.play()


func _on_arach_mode_pressed() -> void:
	arachnofobia = !arachnofobia
	print(arachnofobia)
