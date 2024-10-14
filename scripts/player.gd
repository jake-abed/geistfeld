extends CharacterBody2D

const BASE_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const ACCEL = 10.0
const MAX_ENERGY = 100.0

var speed_scaling = 1.0
var energy := 100.0
var facing_factor := 1.0

@onready var sprite := $Sprite2D
@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play("idle")

func _physics_process(delta: float) -> void:	
	var x_input := Input.get_axis("move_left", "move_right")
	var y_input := Input. get_axis("move_up", "move_down")
	var direction := Vector2(x_input, y_input)
	
	if direction.x > 0:
		facing_factor = 1.0
		sprite.flip_h = false
	elif direction.x < 0:
		facing_factor = -1.0
		sprite.flip_h = true
	
	if Input.is_action_pressed("sprint") and energy > 0:
		energy -= 1.0
		speed_scaling = 1.5
	else:
		speed_scaling = 1.0
	
	if not Input.is_action_pressed("sprint") and energy < MAX_ENERGY:
		energy += 0.75
		if energy > MAX_ENERGY:
			energy = MAX_ENERGY
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if x_input || y_input:
		velocity = velocity.lerp(direction * speed_scaling * BASE_SPEED, ACCEL * delta)
	else:
		velocity = velocity.lerp(Vector2(0.0, 0.0), ACCEL * delta)
	print(velocity)
	
	if velocity.length() != 0 and direction.length() != 0:
		anim_player.play("move")
	else:
		anim_player.play("idle")

	move_and_slide()
