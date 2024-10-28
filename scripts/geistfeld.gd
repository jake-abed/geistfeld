extends Node2D

var wisp_scene := preload("res://scenes/wisp.tscn")
var door_scene := preload("res://scenes/trap_door.tscn")
var door_location_name: String

@onready var door_spawns := get_tree().get_nodes_in_group("door_spawns")
@onready var player := $Player
@onready var player_message := $CanvasLayer/UI/Panel/Label
@onready var ui_anims := $UIAnims
@onready var ui_canvas := $UICanvasLayer
@onready var scene_anims := $SceneAnims

func _ready() -> void:
	spawn_wisps()
	spawn_door()
	player.item_found.connect(_on_item_found)
	for area in get_tree().get_nodes_in_group("key_location"):
		if area is KeyLocation:
			area.entering_location.connect(_on_location_entered)
			area.location_found.connect(_on_location_found)
	scene_anims.play("fade_in")

func spawn_wisps() -> void:
	await Game.getWisps()
	for wisp in Game.wisps:
		var new_wisp = wisp_scene.instantiate()
		var wisp_location = []
		if wisp.has("location"):
			wisp_location = wisp["location"]
		elif wisp.has("position"):
			wisp_location = wisp["position"]
		new_wisp.location = Vector2(wisp_location[0], wisp_location[1])
		new_wisp.global_position = new_wisp.location
		new_wisp.wisp_name = wisp["name"]
		new_wisp.message = wisp["message"]
		get_tree().root.get_node("Geistfeld").add_child(new_wisp)

func spawn_door() -> void:
	var door_inst := door_scene.instantiate()
	var spawn_location = door_spawns.pick_random()
	door_inst.door_repaired.connect(_on_door_repaired)
	door_inst.door_finished.connect(_on_door_finished)
	door_inst.door_opened.connect(_on_door_opened)
	door_inst.items_missing.connect(_on_items_missing)
	door_location_name = spawn_location.location_name
	spawn_location.add_child(door_inst)

func _on_item_found(item: String) -> void:
	if ui_anims.is_playing():
		await ui_anims.animation_finished
	player_message.text = item + " Found"
	ui_anims.play("message_fade")

func _on_door_repaired(item: String) -> void:
	player_message.text = item + " Used to Repair Door"
	if ui_anims.is_playing():
		ui_anims.seek(0.5)
	ui_anims.play("message_fade")

func _on_door_finished() -> void:
	if ui_anims.is_playing():
		await ui_anims.animation_finished
	player_message.text = "Trap Door Repaired"
	if ui_anims.is_playing():
		ui_anims.seek(0.5)
	ui_anims.play("message_fade")

func _on_door_opened() -> void:
	scene_anims.play("fade_out")

func _on_items_missing(items: String) -> void:
	player_message.text = "Items missing: " + items
	if ui_anims.is_playing():
		ui_anims.seek(0.5)
	ui_anims.play("message_fade")

func _on_pause_button_pressed() -> void:
	get_tree().paused = false
	ui_canvas.visible = false

func _on_location_entered(name: String) -> void:
	if ui_anims.is_playing():
		return	
	player_message.text = name
	ui_anims.play("message_fade")

func _on_location_found(location: KeyLocation) -> void:
	if ui_anims.is_playing():
		await ui_anims.animation_finished
	location.map_label.text = location.location_name.replace(" ", "\n")
	player_message.text = location.location_name + " Found"
	ui_anims.play("message_fade")
