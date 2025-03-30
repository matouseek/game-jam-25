extends Node2D

var people : Array = []
const SACRIFICE_TIME : float = 1.5
const DIALOG_TIME : float = 2
const SHIP_TIME : float = 8
@onready var hud = $Prolog/Hud
@onready var natives = $Prolog/Natives
@onready var ship = $Prolog/Ship
@onready var ship_sprite = $Prolog/ShipSprite
@onready var ship_end_place = $Prolog/ShipEndPlace

var natives_dialog : Array[String] = ["Spirits be with you travelers...", "Our gods crave blood, how many of our people shall we sacrifice?"]
var ship_dialog : Array[String] = ["Greetings people of the wild! What do you wish from us?", "Well..."]

var travell_back_natives_zero_response : String = "Hold up... how did you do that"
var travell_back_ship_non_zero_response : String = "You could've saved them, we know the concept of zero... asshole"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	people = $Falling/People.get_children()
	hud.digit_pressed.connect(sacrifice)
	hud.visible = false
	if GM.travelling_back:
		travel_back()
	else: first_time()

func first_time():
	await ship_arrive(ship_sprite, ship_end_place)
	play_dialog(natives_dialog, ship_dialog)

func travel_back():
	hud.current_layout = hud.Layout.ZERO
	hud.setup(hud.layouts[hud.current_layout])
	
	await ship_arrive(ship_sprite, ship_end_place)
	play_dialog(natives_dialog, ship_dialog)

func play_dialog(natives_d : Array[String], ship_d : Array[String]):
	natives.text = natives_d[0]
	ship.text = ship_d[0]
	
	var tween = get_tree().create_tween()
	tween.tween_property(natives, "modulate:a", 1, DIALOG_TIME)
	tween.tween_property(ship, "modulate:a", 1, DIALOG_TIME)
	
	await tween.finished
	
	tween = get_tree().create_tween().tween_property(natives, "modulate:a", 0, DIALOG_TIME)
	
	await tween.finished
	
	natives.text = natives_d[1]
	
	tween = get_tree().create_tween()
	tween.tween_property(natives, "modulate:a", 1, DIALOG_TIME)
	tween.tween_property(ship, "modulate:a", 0, DIALOG_TIME)
	
	await tween.finished
	
	ship.text = ship_d[1]
	
	tween = get_tree().create_tween().tween_property(ship, "modulate:a", 1, DIALOG_TIME)
	
	await tween.finished
	hud.visible = true
	tween = get_tree().create_tween()
	tween.tween_property(hud, "modulate:a", 1, 0.5)

func ship_arrive(ship_sprite : Sprite2D, end_location : Node2D):
	var ship_arrival_time := SHIP_TIME
	
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(ship_sprite, "position", end_location.position, ship_arrival_time)
	
	await tween.finished
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func spread_people():
	##var chunk_size : float = get_viewport().size.x / (len(people) + 1)
	#var chunk_size : float = float(GM.WINDOW_WIDTH) / (len(people) + 1)
	#var current_pos : float = chunk_size
	#var TOP_OFFSET = 1/4.0
	#var y =  get_viewport().size.y * TOP_OFFSET 
	#for p in people:
		#var sprite = p as Area2D
		#sprite.position.x = current_pos
		#current_pos += chunk_size
		#sprite.position.y = y

func sacrifice(to_sacrifice : int):
	disable_hud()
	if to_sacrifice >= 1:
		if GM.travelling_back:
				var tween = get_tree().create_tween()
				tween.tween_property(ship, "modulate:a", 0, DIALOG_TIME)
				
				await tween.finished
				
				ship.text = travell_back_ship_non_zero_response
				
				tween = get_tree().create_tween()
				tween.tween_property(ship, "modulate:a", 1, DIALOG_TIME)
				
				await get_tree().create_timer(3).timeout
				
		$Prolog.visible = false
		$Falling.visible = true
		hud.process_mode = Node.PROCESS_MODE_DISABLED
		var hud_tween = get_tree().create_tween()
		hud_tween.tween_property(hud, "modulate:a", 0, 0.5)
		hud_tween.tween_callback(func(): hud.visible = false)
		for i in range(to_sacrifice):
			var sprite = people[i] as Person
			sprite.run(300)
		await get_tree().create_timer(5).timeout
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(natives, "modulate:a", 0, DIALOG_TIME)
		
		await tween.finished
		
		natives.text = travell_back_natives_zero_response
		
		tween = get_tree().create_tween()
		tween.tween_property(natives, "modulate:a", 1, DIALOG_TIME)
		
		await get_tree().create_timer(3).timeout
	GM.level_completed.emit()
	
	
func disable_hud(): $Prolog/Hud.process_mode = Node.PROCESS_MODE_DISABLED
