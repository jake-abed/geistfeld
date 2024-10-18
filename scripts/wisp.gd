class_name Wisp extends Interactable

@export var wisp_name: String
@export var location: Vector2
@export var message: String

@onready var panel := $Panel
@onready var name_label := $Panel/NameLabel
@onready var message_label := $Panel/MessageLabel
@onready var sprite := $Sprite2D

func _ready() -> void:
	type = "wisp"
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	name_label.text = wisp_name
	message_label.text = message
	play_float_anim()

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
	
	var pos_offset_up := global_position.y - 3.0
	var pos_offset_down := pos_offset_up + 6.0
	var duration := 2.8
	
	tween.tween_property(sprite, "global_position:y", pos_offset_up, duration)
	tween.tween_property(sprite, "global_position:y", pos_offset_down, duration)
	tween2.tween_property(sprite, "scale", sprite.scale * 1.125, duration * 2.1)
	tween2.tween_property(sprite, "scale", sprite.scale * 0.9, duration * 2.1)
	tween.set_loops()
	tween2.set_loops()