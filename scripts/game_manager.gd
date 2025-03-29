extends CanvasLayer

const PATH_TO_SCENES := "res://scenes/minigames/" 
const SCENES := ["0math_formulas.tscn","1sacrifice.tscn","2shooting_balls.tscn"] ## contains filenames for scenes in sequential order

const MAP_SCENE_PATH := "res://scenes/map.tscn"

signal level_completed ## each minigame emits it when done
signal map_completed ## emits by map when player chose next minigame

var current_level : int = 0 ## tracks the current game state
var TIME : float = 0.5
@onready var fade : ColorRect = $Fade
@onready var sfx : AudioStreamPlayer = $SFX
@onready var music : AudioStreamPlayer = $Music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_completed.connect(switch_to_map)
	map_completed.connect(load_level)
	music.volume_db = $Menu/MusicVolume.value
	sfx.volume_db = $Menu/SFXVolume.value
	play_music('res://assets/music/skibidi.mp3')
	

# loads map scene and increases the current level count
func switch_to_map() -> void:
	current_level += 1
	fading(MAP_SCENE_PATH)

# TODO: fade in/out
func load_level() -> void:
	fading(PATH_TO_SCENES + SCENES[current_level])
	
func fading(scene) -> void:
	fade.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(fade,"color:a",1,TIME)
	var timer = get_tree().create_timer(TIME)
	await timer.timeout
	get_tree().change_scene_to_file(scene)
	tween = get_tree().create_tween()
	tween.tween_property(fade,"color:a",0,TIME)
	timer = get_tree().create_timer(TIME)
	await timer.timeout
	fade.visible = false

func menu_toggle() -> void:
	$Menu.visible = !$Menu.visible
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"): menu_toggle()
	

func _on_back_pressed() -> void:
	menu_toggle()


func _on_sfx_volume_value_changed(value: float) -> void:
	sfx.volume_db = value


func _on_music_volume_value_changed(value: float) -> void:
	music.volume_db = value

func play_music(name: String):
	music.stream = load(name) as AudioStream
	music.play()

func _on_music_finished() -> void:
	music.play()
