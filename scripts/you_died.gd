extends Control

@onready var name_edit := $Panel/NameEdit
@onready var message_edit := $Panel/MessageEdit
@onready var submit := $Panel/Button
@onready var reject := $Panel/Button2

func _ready() -> void:
	submit.pressed.connect(_on_submit_pressed)
	reject.pressed.connect(_on_reject_pressed)

func _on_submit_pressed() -> void:
	if name_edit.text == '':
		return
	if message_edit.text == '':
		return
	var death_coord := [Game.player_death_location.x, Game.player_death_location.y]
	var wisp := {
		"name": name_edit.text,
		"location": death_coord,
		"message": message_edit.text
	}
	await Game.addWisp(wisp)
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_reject_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
