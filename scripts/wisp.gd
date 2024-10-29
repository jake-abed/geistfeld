class_name Wisp extends Interactable

@export var wisp_name: String
@export var location: Vector2
@export var message: String

@onready var panel := $Panel
@onready var name_label := $Panel/NameLabel
@onready var message_label := $Panel/MessageLabel
@onready var blessing_label := $Panel/BlessingLabel
@onready var sprite := $Sprite2D

var blessing: String
var blessing_types := ["Speed", "Energy", "Banish"]

func _ready() -> void:
	type = "wisp"
	play_float_anim()
	blessing = blessing_types.pick_random()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	name_label.text = wisp_name
	message_label.text = message
	blessing_label.text= "Blessing 'o " + blessing
	

func _on_body_entered(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		panel.visible = true
		body.interactables.push_back(self)

func _on_body_exited(body) -> void:
	if body is StaticBody2D:
		return
	if body is Player:
		panel.visible = false
		var index: int = body.interactables.find(self)
		if index >= 0:
			body.interactables.pop_at(index)
		return

func play_float_anim() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var tween2 := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var pos_offset_up := global_position.y - 5.0
	var pos_offset_down := pos_offset_up + 9.0
	var duration_one := randf_range(2.5, 3.5)
	var duration_two := randf_range(0.8, 1.2)
	tween.set_parallel(false)
	tween2.set_parallel(false)
	tween.set_loops(0)
	tween2.set_loops(0)
	
	tween.tween_property(sprite, "global_position:y", pos_offset_up, duration_one)
	tween.tween_property(sprite, "global_position:y", pos_offset_down, duration_one)
	tween2.tween_property(sprite, "scale", sprite.scale * 1.15, duration_two)
	tween2.tween_property(sprite, "scale", sprite.scale * 0.9, duration_two)

func bless(player: Player) -> void:
	player.receive_blessing(blessing)
	self.queue_free()
