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
	print(contact_shape.shape.radius)

func _process(_delta: float) -> void:
	pass


func choose_new_location() -> void:
	if player_targeted:
		return
	if !!target_location:
		return
	var x_cord = randi_range(LEFT_BOUND, RIGHT_BOUND)
	var y_cord = randi_range(TOP_BOUND, BOTTOM_BOUND)
