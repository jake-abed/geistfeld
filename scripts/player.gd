class_name Player extends CharacterBody2D

signal item_found(item: String)

const ACCEL := 10.0

var base_speed := 450.0
var speed_scaling := 1.0
var max_energy := 100.0
var energy := 100.0
var banish_cooldown := 7.0
var banish_radius := 60.0
var can_banish := true
var banishing := false
var facing_factor := 1.0

var banish_scene := preload("res://scenes/banish.tscn")

@onready var sprite := $Sprite2D
@onready var anim_player := $AnimationPlayer
@onready var light := $PointLight2D
@onready var light_timer := $LightTimer
@onready var banish_timer := $BanishTimer
@onready var banish_audio := $BanishAudio
@onready var blessing_audio := $BlessingAudio

var interactables: Array[Interactable] = []

var inventory := {
	"Key": false,
	"Oil Can": false,
	"Crow Bar": false,
	"Handle": false,
	"Gormfeld": false
}

func _ready() -> void:
	anim_player.play("idle")
	glow_light()
	light_timer.timeout.connect(_on_light_timer_timeout)
	banish_timer.timeout.connect(_on_banish_timer_timeout)
	anim_player.animation_finished.connect(_on_anim_finished)

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
		speed_scaling = 1.75
	else:
		speed_scaling = 1.0
	
	if not Input.is_action_pressed("sprint") and energy < max_energy:
		energy += 0.75
		if energy > max_energy:
			energy = max_energy
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if (x_input || y_input) and not banishing:
		velocity = velocity.lerp(direction * speed_scaling * base_speed, ACCEL * delta)
	else:
		velocity = velocity.lerp(Vector2(0.0, 0.0), ACCEL * delta)
	
	if velocity.length() != 0 and direction.length() != 0 and not banishing:
		anim_player.play("move")
	elif not banishing:
		anim_player.play("idle")
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_just_pressed("banish") and can_banish:
		banish()

	move_and_slide()

func interact() -> void:
	if len(interactables) == 0:
		return
	match interactables[0].type:
		"note":
			interactables[0].toggle_note()
		"wisp":
			interactables[0].bless(self)
			blessing_audio.play()
		"item_container":
			inventory[interactables[0].item_name] = true
			interactables[0].contains_item = false
			item_found.emit(interactables[0].item_name)
			interactables[0].play_audio()
			interactables[0].delete_collision_shape()
		"door":
			interactables[0].repair_door(self)

func glow_light() -> void:
	var tween := create_tween()
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

func _on_banish_timer_timeout() -> void:
	can_banish = true
	banish_timer.wait_time = banish_cooldown

func flicker_light() -> void:
	var tween := create_tween()
	var low := randf_range(1, 1.1)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(false)
	tween.tween_property(light, "energy", low, 0.25)
	tween.tween_property(light, "energy", 1.25, 0.25)

func banish() -> void:
	banishing = true
	anim_player.play("banish")
	banish_audio.play()
	can_banish = false
	var banish_inst := banish_scene.instantiate()
	banish_inst.radius = banish_radius
	add_child(banish_inst)
	banish_timer.start()

func _on_anim_finished(anim) -> void:
	if anim == "banish":
		banishing = false

func has_all_necessary_items() -> bool:
	return (inventory["Key"] and
	inventory["Oil Can"] and
	inventory ["Crow Bar"] and
	inventory["Handle"])

func die() -> void:
	Game.player_death_location = global_position
	get_tree().call_deferred("change_scene_to_file", "res://scenes/you_died.tscn")
