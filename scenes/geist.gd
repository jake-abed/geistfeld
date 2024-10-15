extends Node2D

const LEFT_BOUND := 100
const RIGHT_BOUND := 12550
const TOP_BOUND := 100
const BOTTOM_BOUND := 7200
const BASE_SPEED := 50
const BASE_RADIUS := 1250

@onready var contact_box := $ContactBox
@onready var contact_shape := $ContactBox/CollisionShape2D
@onready var hit_box := $Hitbox


var player_targeted := false
var player: Player
var target_location: Vector2

func _ready() -> void:
	choose_new_location()
	contact_box.body_entered.connect(_on_contact_body_entered)
	contact_box.body_exited.connect(_on_contact_body_exited)

func _process(delta: float) -> void:
	if global_position == target_location:
		choose_new_location()
	
	if !player_targeted:
		var movement = (target_location - global_position).normalized()
		global_position += movement * BASE_SPEED * delta
	else:
		var movement = (player.global_position - global_position).normalized()
		global_position += movement * BASE_SPEED * delta

func choose_new_location() -> void:
	if player_targeted:
		return
	var x_cord = randi_range(LEFT_BOUND, RIGHT_BOUND)
	var y_cord = randi_range(TOP_BOUND, BOTTOM_BOUND)
	target_location = Vector2(x_cord, y_cord)
	print(target_location)

func _on_contact_body_entered(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		player_targeted = true
		player = body

func _on_contact_body_exited(body) -> void:
	if body is StaticBody2D:
		return
	print(body, " exited")
	if body is Player:
		player_targeted = false
		choose_new_location()
