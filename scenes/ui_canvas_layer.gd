extends CanvasLayer

@onready var button := $Control/Panel2/Button

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_button_pressed() -> void:
	hide()
	get_tree().paused = false
