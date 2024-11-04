class_name Banish extends Area2D

@onready var collision_shape := $CollisionShape2D
@export var radius := 50.0

func _ready() -> void:
	global_position.y += 16
	area_entered.connect(_on_area_entered)
	banish(radius)

func banish(r: float) -> void:
	var tween := create_tween()
	collision_shape.shape.radius = 0.1
	tween.tween_property(collision_shape.shape, "radius", r, 0.05)
	await tween.finished
	self.queue_free()

func _on_area_entered(area) -> void:
	if area is Geist:
		area.banish()
		self.queue_free()
