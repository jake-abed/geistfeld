extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		get_tree().paused = false
