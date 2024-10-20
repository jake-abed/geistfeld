class_name ItemContainer extends Interactable

@export var item_name: String
@export var contains_item := true

@onready var panel := $Panel
@onready var audio := $AudioStreamPlayer2D

func _ready() -> void:
	type = "item_container"
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body) -> void:
	if body is Player:
		body.interactables.push_back(self)
		panel.visible = true

func _on_body_exited(body) -> void:
	if body is Player:
		panel.visible = false
		var index: int = body.interactables.find(self)
		if index >= 0:
			body.interactables.pop_at(index)
		return

func play_audio() -> void:
	audio.play()

func delete_collision_shape() -> void:
	var collision_shape = get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.queue_free()
