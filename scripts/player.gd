extends CharacterBody2D


const BASE_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCEL = 10.0
const MAX_ENERGY = 100.0
var speed_scaling = 1.0
var energy := 100.0

func _physics_process(delta: float) -> void:	
	var x_input := Input.get_axis("move_left", "move_right")
	var y_input := Input. get_axis("move_up", "move_down")
	var direction := Vector2(x_input, y_input)
	
	if Input.is_action_pressed("sprint") and energy > 0:
		energy -= 1.0
		speed_scaling = 2.0
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
	move_and_slide()
