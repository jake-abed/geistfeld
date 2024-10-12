class_name Obstacle extends StaticBody2D

@export_enum("CircleShape2D", "RectangleShape2D") var collision_shape_name: String = "CircleShape2D"
@export var radius: int = 1
@export var height: int = 1
@export var width: int = 1

@onready var collision_shape := $CollisionShape2D
@onready var sprite := $Sprite

func _ready() -> void:
	assign_shape()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func assign_shape() -> void:
	match collision_shape_name:
		"CircleShape2D":
			var circle := CircleShape2D.new()
			circle.radius = radius
			collision_shape.shape = circle
		"RectangleShape2D":
			var rect := RectangleShape2D.new()
			rect.size.x = width
			rect.size.y = height
			collision_shape.shape = rect
