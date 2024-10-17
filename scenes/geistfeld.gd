extends Node2D

func _ready() -> void:
	await Game.getWisps()
	for wisp in Game.wisps:
		print(wisp)
	#var test_wisp = {
	#	"name": "Spooky",
	#	"position": [3110, 6969],
	#	"message": "Fuck, I could use a snack? Where is 7/11?"
	#}
	#await Game.addWisp(test_wisp)

func _process(_delta: float) -> void:
	pass
