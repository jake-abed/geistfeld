class_name Interactable extends Area2D

@export var type: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		body.interactables.push_back(self)

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is Player:
		var index: int = body.interactables.find(self)
		if index >= 0:
			body.interactables.pop_at(index)
		return
