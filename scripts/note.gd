class_name Note extends Interactable

@export_multiline var message: String

@onready var control := $CanvasLayer
@onready var label := $CanvasLayer/Control/Panel/Label
@onready var audio := $AudioStreamPlayer2D

func _ready() -> void:
	label.text = message
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_d: float) -> void:
	pass

func toggle_note() -> void:
	if not control.visible:
		audio.play()
	control.visible = !control.visible

func _on_body_entered(body) -> void:
	if body is Player:
		body.interactables.push_back(self)

func _on_body_exited(body) -> void:
	if body is Player:
		if body.interactables[0] == self:
			body.interactables.pop_front()
	if control.visible:
		control.visible = false
