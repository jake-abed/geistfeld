class_name Player extends CharacterBody2D

signal item_found(item: String)
signal blessing_received(blessing: String)

const ACCEL := 10.0

var base_speed := 250.0
var speed_scaling := 1.0
var max_energy := 100.0
var energy := 100.0
var energy_recovery_rate := 25.0
var banish_cooldown := 7.0
var banish_radius := 60.0
var can_banish := true
var can_sprint := true
var banishing := false
var facing_factor := 1.0
var trapdoor_found := false

var banish_scene := preload("res://scenes/banish.tscn")

@onready var sprite := $Sprite2D
@onready var anim_player := $AnimationPlayer
@onready var light := $PointLight2D
@onready var light_timer := $LightTimer
@onready var banish_timer := $BanishTimer
@onready var banish_audio := $BanishAudio
@onready var banish_area := $BanishArea
@onready var banish_area_shape := $BanishArea/CollisionShape2D
@onready var blessing_audio := $BlessingAudio
@onready var breathing_audio := $BreathingAudio
@onready var breathing_timer := $BreathingTimer

var blessing_level := {
	"Speed": 0,
	"Energy": 0,
	"Banish": 0
}

var interactables: Array[Interactable] = []

var inventory := {
	"Key": false,
	"Oil Can": false,
	"Crow Bar": false,
	"Handle": false,
	"Gormfeld": false
}

var areas_found := {}

func _ready() -> void:
	anim_player.play("idle")
	glow_light()
	light_timer.timeout.connect(_on_light_timer_timeout)
	banish_timer.timeout.connect(_on_banish_timer_timeout)
	breathing_timer.timeout.connect(_on_breathing_timer_timeout)
	anim_player.animation_finished.connect(_on_anim_finished)
	banish_area.area_entered.connect(_on_banish_area_entered)
	banish_area.area_exited.connect(_on_banish_area_exited)

func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return
	var x_input := Input.get_axis("move_left", "move_right")
	var y_input := Input. get_axis("move_up", "move_down")
	var direction := Vector2(x_input, y_input)
	
	if direction.x > 0:
		facing_factor = 1.0
		sprite.flip_h = false
	elif direction.x < 0:
		facing_factor = -1.0
		sprite.flip_h = true
	
	if Input.is_action_pressed("sprint") and (x_input or y_input) and can_sprint and energy > 0:
		energy -= 1.0
		speed_scaling = 1.75
	else:
		speed_scaling = 1.0
	
	if can_sprint and energy <= 0:
		energy_depleted()
		can_sprint = false
	
	if (not Input.is_action_pressed("sprint") or !can_sprint) and energy < max_energy:
		energy += energy_recovery_rate * delta
		if energy >= max_energy:
			energy = max_energy
			can_sprint = true
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if (x_input || y_input) and not banishing and not get_tree().paused:
		velocity = velocity.lerp(direction * speed_scaling * base_speed, ACCEL * delta)
	else:
		velocity = velocity.lerp(Vector2(0.0, 0.0), ACCEL * delta)
	
	if velocity.length() != 0 and direction.length() != 0 and not banishing:
		anim_player.play("move")
	elif not banishing:
		anim_player.play("idle")
	
	if Input.is_action_just_pressed("interact") and not get_tree().paused:
		interact()
	
	if Input.is_action_just_pressed("banish") and can_banish and not get_tree().paused:
		banish()

	move_and_slide()

func has_all_necessary_items() -> bool:
	return (inventory["Key"] and
	inventory["Oil Can"] and
	inventory ["Crow Bar"] and
	inventory["Handle"])

func die() -> void:
	Game.player_death_location = global_position
	get_tree().call_deferred("change_scene_to_file", "res://scenes/you_died.tscn")

func banish() -> void:
	banishing = true
	anim_player.play("banish")
	banish_audio.play()
	can_banish = false
	var banish_inst := banish_scene.instantiate()
	banish_inst.radius = banish_radius
	add_child(banish_inst)
	banish_timer.start()

func receive_blessing(blessing: String) -> void:
	blessing_level[blessing] += 1
	match blessing:
		"Speed":
			base_speed += 15
		"Energy":
			max_energy += 25
			energy += 25
			energy_recovery_rate += 7.5
		"Banish":
			if banish_cooldown > 1.0:
				banish_cooldown -= 0.5
			banish_radius += 7.0
			banish_area_shape.shape.radius += 7.0
	blessing_received.emit(blessing)

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
			if interactables[0].item_name != "":
				inventory[interactables[0].item_name] = true
				interactables[0].contains_item = false
				item_found.emit(interactables[0].item_name)
			else:
				item_found.emit("Nothing")
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

func flicker_light() -> void:
	var tween := create_tween()
	var low := randf_range(1, 1.1)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(false)
	tween.tween_property(light, "energy", low, 0.25)
	tween.tween_property(light, "energy", 1.25, 0.25)

func energy_depleted() -> void:
	breathing_audio.play()
	breathing_timer.start()
# Here be signal functions.

func _on_light_timer_timeout() -> void:
	flicker_light()
	light_timer.wait_time = randf_range(0.25, 3)

func _on_banish_timer_timeout() -> void:
	can_banish = true
	banish_timer.wait_time = banish_cooldown

func _on_breathing_timer_timeout() -> void:
	breathing_audio.pitch_scale = randf_range(1.0, 1.2)
	breathing_timer.wait_time = randf_range(1.55, 1.7)
	breathing_audio.stop()
	breathing_audio.seek(0.0)
	if !can_sprint:
		breathing_audio.play()
		breathing_timer.start()
	else:
		breathing_audio.stop()
		breathing_timer.wait_time = 2.0

func _on_anim_finished(anim) -> void:
	if anim == "banish":
		banishing = false

func _on_banish_area_entered(node: Node2D) -> void:
	if node is Geist:
		node.shine()

func _on_banish_area_exited(node: Node2D) -> void:
	if node is Geist:
		node.stop_shine()
