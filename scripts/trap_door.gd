class_name TrapDoor extends Interactable

@onready var sprite := $Sprite2D
@onready var handle_sprite := $HandleSprite

var has_handle := false
var has_oil := false
var has_crowbar := false
var has_key := false

func add_handle() -> void:
	handle_sprite.visible = true
