extends Node2D

var wisp_scene := preload("res://scenes/wisp.tscn")

func _ready() -> void:
	await Game.getWisps()
	for wisp in Game.wisps:
		var new_wisp = wisp_scene.instantiate()
		var wisp_location = []
		if wisp.has("location"):
			wisp_location = wisp["location"]
		elif wisp.has("position"):
			wisp_location = wisp["position"]
		new_wisp.location = Vector2(wisp_location[0], wisp_location[1])
		new_wisp.global_position = new_wisp.location
		new_wisp.wisp_name = wisp["name"]
		new_wisp.message = wisp["message"]
		get_tree().root.get_node("Geistfeld").add_child(new_wisp)

func _process(_delta: float) -> void:
	pass
