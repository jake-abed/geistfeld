extends Control

@export var next_scene: String

@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play("fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(next_scene)
