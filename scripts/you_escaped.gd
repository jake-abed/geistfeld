extends Control

@onready var button := $Panel/Button
@onready var title := load("res://scenes/title_screen.tscn")

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(title)
