class_name Note extends Interactable

@export_multiline var message: String

@onready var control := $CanvasLayer
@onready var label := $CanvasLayer/Control/Panel/Label

func _ready() -> void:
	label.text = message
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_d: float) -> void:
	pass

func toggle_note() -> void:
	control.visible = !control.visible

func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		body.interactable = self

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is Player:
		if body.interactable == self:
			body.interactable = null
	if control.visible:
		control.visible = false