extends Node2D

@onready var button := $CanvasLayer/UI/Panel/Button
@onready var anims := $AnimationPlayer
@onready var geistfeld := load("res://scenes/geistfeld.tscn")

func _ready() -> void:
	anims.play("fade_in")
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	enter_geistfeld()

func enter_geistfeld() -> void:
	anims.play("fade_out")
	await anims.animation_finished
	get_tree().change_scene_to_packed(geistfeld)
