class_name KeyLocation extends Node2D

@export var location_name: String
@export var door_possible: bool

func _ready() -> void:
	if is_in_group("door_spawns"):
		door_possible = true
