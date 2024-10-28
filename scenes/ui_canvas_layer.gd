extends CanvasLayer

@onready var control_tab := $Control/TabContainer

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_visibility_changed() -> void:
	if visible:
		control_tab.get_tab_bar().call_deferred("grab_focus")
