extends Control

@onready var name_edit := $Panel/NameEdit
@onready var message_edit := $Panel/MessageEdit
@onready var submit := $Panel/Button

func _ready() -> void:
	submit.pressed.connect(_on_submit_pressed)

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
	get_tree().change_scene_to_file("res://scenes/geistfeld.tscn")
