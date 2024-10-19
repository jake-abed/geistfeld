extends StaticBody2D

@onready var sprite := $Sprite2D
@onready var shader_mat: ShaderMaterial = sprite.material

func _ready() -> void:
	shader_mat.set_shader_parameter("minStrength", randf_range(0.05, 0.1))
	shader_mat.set_shader_parameter("maxStrength", randf_range(0.2, 0.3))
	shader_mat.set_shader_parameter("interval", randf_range(4.0, 6.0))
