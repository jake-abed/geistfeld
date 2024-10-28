class_name KeyLocation extends Area2D

signal location_found(area: KeyLocation)
signal entering_location(name: String)

@export var location_name: String
@export var door_possible: bool
@export var map_label: Label

func _ready() -> void:
	if is_in_group("door_spawns"):
		door_possible = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.areas_found.has(location_name):
			entering_location.emit(location_name)
		else:
			body.areas_found[location_name] = true
			location_found.emit(self)
