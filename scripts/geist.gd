class_name Geist extends Area2D

const LEFT_BOUND := 1280
const RIGHT_BOUND := 11550
const TOP_BOUND := 1000
const BOTTOM_BOUND := 6380
const BASE_SPEED := 100.0
const BASE_RADIUS := 1300.0
const LEVEL_UP_TIME := 30.0

@onready var sprite := $Sprite2D
@onready var light := $PointLight2D
@onready var contact_box := $ContactBox
@onready var contact_shape := $ContactBox/CollisionShape2D
@onready var level_up_timer := $LevelUpTimer
@onready var banish_timer := $BanishTimer

@onready var speed: float
@onready var contact_radius: float
@onready var level := 1

var player_targeted := false
var player: Player
var target_location: Vector2
var banished := false

func _ready() -> void:
	reset_ghost()
	gloob_and_shoob()
	contact_box.body_entered.connect(_on_contact_body_entered)
	contact_box.body_exited.connect(_on_contact_body_exited)
	body_entered.connect(_on_hitbox_body_entered)
	level_up_timer.timeout.connect(_on_level_up_timeout)
	banish_timer.timeout.connect(_on_banish_timeout)

func _process(delta: float) -> void:
	if global_position == target_location:
		choose_new_location()
	
	if !player_targeted:
		var movement = (target_location - global_position).normalized()
		if banished:
			movement *= -1 * (8 / level)
		global_position += movement * speed * delta
		set_sprite_direction(target_location - global_position)
	else:
		var movement = (player.global_position - global_position).normalized()
		if banished:
			movement *= -1 * (8 / level)
		global_position += movement * speed * delta
		set_sprite_direction(player.global_position - global_position)

func choose_new_location() -> void:
	if player_targeted:
		return
	var x_cord = randi_range(LEFT_BOUND, RIGHT_BOUND)
	var y_cord = randi_range(TOP_BOUND, BOTTOM_BOUND)
	target_location = Vector2(x_cord, y_cord)

func _on_contact_body_entered(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		player_targeted = true
		player = body

func _on_hitbox_body_entered(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		speed = 0
		body.die()

func set_sprite_direction(movement: Vector2) -> void:
	if movement.x > 1.0:
		sprite.flip_h = true
		light.position.x = -15
	if movement.x < -1.0:
		sprite.flip_h = false
		light.position.x = 15

func _on_contact_body_exited(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		player_targeted = false
		choose_new_location()

func gloob_and_shoob() -> void:
	var initial_scale = scale
	var target_y_scale = scale.y * 1.02
	var target_x_scale = scale.x * 1.025
	var tween = create_tween()
	var squish_tween = create_tween()
	
	tween.set_loops()
	squish_tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	squish_tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	squish_tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale:y", target_y_scale, 0.5)
	tween.tween_property(self, "scale:y", initial_scale.y, 0.5)
	squish_tween.tween_property(self, "scale:x", target_x_scale, 0.5)
	squish_tween.tween_property(self, "scale:x", initial_scale.x, 0.5)

func reset_ghost() -> void:
	choose_new_location()
	speed = BASE_SPEED
	contact_radius = BASE_RADIUS
	level = 1
	level_up_timer.wait_time = LEVEL_UP_TIME

func level_up() -> void:
	if level > 14:
		return
	level += 1
	speed *= 1.1
	contact_radius *= 1.15
	contact_shape.shape.radius = contact_radius

func level_down() -> void:
	if level == 1:
		return
	level -= 1
	speed /= 1.1
	contact_radius /= 1.15
	contact_shape.shape.radius = contact_radius

func banish() -> void:
	banished = true
	banish_timer.start()

func _on_banish_timeout() -> void:
	banished = false
	banish_timer.wait_time = 3

func _on_level_up_timeout() -> void:
	level_up()
	print("Leveling up to level ", level)
	level_up_timer.wait_time = LEVEL_UP_TIME + level
