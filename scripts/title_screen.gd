extends Node2D

@onready var button := $CanvasLayer/UI/Panel/Button
@onready var anims := $AnimationPlayer
@onready var dummy := $DummyPlayer/AnimationPlayer
@onready var geist := $Geist/AnimationPlayer
@onready var geistfeld := load("res://scenes/geistfeld.tscn")

func _ready() -> void:
	anims.play("fade_in")
	dummy.play("idle")
	geist.play("idle")
	button.pressed.connect(_on_button_pressed)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		enter_geistfeld()

func _on_button_pressed() -> void:
	enter_geistfeld()

func enter_geistfeld() -> void:
	anims.play("fade_out")
	await anims.animation_finished
	get_tree().change_scene_to_packed(geistfeld)
