class_name TrapDoor extends Interactable

signal door_found()
signal door_repaired(item: String)
signal items_missing(items: String)
signal door_finished()
signal door_opened()

@onready var sprite := $Sprite2D
@onready var handle_sprite := $HandleSprite
@onready var panel := $Panel
@onready var label := $Panel/NameLabel
@onready var repair_audio := $RepairAudio
@onready var open_audio := $OpenAudio
@onready var you_escaped := load("res://scenes/you_escaped.tscn")
@onready var visible_area := $VisibleArea

var has_handle := false
var has_oil := false
var has_crow_bar := false
var has_key := false
var repaired := false

func repair_door(p: Player) -> void:
	if repaired:
		open_door()
	if p.has_all_necessary_items():
		has_handle = true
		has_oil = true
		has_crow_bar = true
		has_key = true
		repaired = true
		label.text = "E - Exit Geistfeld?"
		door_finished.emit()
		return
	if not has_handle and p.inventory["Handle"]:
		add_handle()
		has_handle = true
		repair_audio.play()
		door_repaired.emit("Handle")
		return
	if not has_oil and p.inventory["Oil Can"]:
		has_oil = true
		repair_audio.play()
		door_repaired.emit("Oil Can")
		return
	if not has_crow_bar and p.inventory["Crow Bar"]:
		has_crow_bar = true
		repair_audio.play()
		door_repaired.emit("Crow Bar")
		return
	if not has_key and p.inventory["Key"]:
		has_key = true
		repair_audio.play()
		door_repaired.emit("Key")
		return
	items_missing.emit(items_missing_message())

func is_door_repaired() -> bool:
	return has_handle and has_oil and has_crow_bar and has_key

func add_handle() -> void:
	handle_sprite.visible = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		panel.visible = true
		body.interactables.push_back(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		panel.visible = false
		var index: int = body.interactables.find(self)
		if index >= 0:
			body.interactables.pop_at(index)
		return

func open_door() -> void:
	var geists = get_tree().get_nodes_in_group("geists")
	for geist in geists:
		if geist is Geist:
			if geist.player_targeted:
				geist.banish()
	door_opened.emit()
	open_audio.play()
	await open_audio.finished
	get_tree().change_scene_to_packed(you_escaped)

func delete_collision_shape() -> void:
	var collision_shape = get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.queue_free()

func items_missing_message() -> String:
	var items: Array[String] = []
	if not has_handle:
		items.append("Handle")
	if not has_crow_bar:
		items.append("Crow Bar")
	if not has_key:
		items.append("Key")
	if not has_oil:
		items.append("Oil")
	return ", ".join(items)

func _on_visible_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.trapdoor_found:
			body.trapdoor_found = true
			door_found.emit()
