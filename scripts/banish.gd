class_name Banish extends Area2D

@onready var collision_shape := $CollisionShape2D
@export var radius := 50.0

func _ready() -> void:
	print(global_position)
	area_entered.connect(_on_area_entered)
	banish(radius)

func banish(radius: int) -> void:
	var tween := create_tween()
	tween.tween_property(collision_shape.shape, "radius", radius, 0.025)
	await tween.finished
	self.queue_free()

func _on_area_entered(area) -> void:
	if area is Geist:
		print("banishing geist")
		area.banish()
		self.queue_free()
