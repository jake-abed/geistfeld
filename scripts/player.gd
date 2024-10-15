class_name Player extends CharacterBody2D

const BASE_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const ACCEL = 10.0
const MAX_ENERGY = 100.0

var speed_scaling = 1.0
var energy := 100.0
var facing_factor := 1.0

@onready var sprite := $Sprite2D
@onready var anim_player := $AnimationPlayer
@onready var light := $PointLight2D
@onready var light_timer := $LightTimer

var interactable: Interactable

func _ready() -> void:
	anim_player.play("idle")
	glow_light()
	light_timer.timeout.connect(_on_light_timer_timeout)

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
	
	if velocity.length() != 0 and direction.length() != 0:
		anim_player.play("move")
	else:
		anim_player.play("idle")
	
	if Input.is_action_just_pressed("interact"):
		print("interact pressed")
		interact()

	move_and_slide()

func interact() -> void:
	print("trying to interact")
	if !interactable:
		return
	match interactable.type:
		"note":
			interactable.toggle_note()

func glow_light() -> void:
	var tween := get_tree().create_tween()
	var current: Vector2 = light.scale
	var small: Vector2 = light.scale * 0.75
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops(0)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(false)
	tween.tween_property(light, "scale", small, randf_range(2, 3))
	tween.tween_property(light, "scale", current, randf_range(2, 3))

func _on_light_timer_timeout() -> void:
	flicker_light()
	light_timer.wait_time = randf_range(0.25, 3)

func flicker_light() -> void:
	var tween := get_tree().create_tween()
	var low := randf_range(1, 1.1)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(false)
	tween.tween_property(light, "energy", low, 0.25)
	tween.tween_property(light, "energy", 1.25, 0.25)
