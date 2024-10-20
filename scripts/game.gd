extends Node

@onready var add_wisp_req := HTTPRequest.new()
@onready var get_wisps_req := HTTPRequest.new()
@onready var wisps: = []

var backup_wisps := [
	{ "name": "Tony Da Deer", "location": [420, 6900], "message": "I am a deer who eats meat! No ******* leaves allowed!", "createdAt": "2024-10-17T20:36:25.823Z" },
	{ "message": "****, I could use a snack? Where is 7/11?", "name": "Spooky", "position": [3110, 6969], "createdAt": "2024-10-17T21:50:43.115Z" },
	{ "location": [2816.70166015625, 1664.09436035156], "message": "I love pork and beans, but not now!", "name": "Franky", "createdAt": "2024-10-18T00:15:08.955Z" },
	{ "location": [1336.21618652344, 1199.720703125], "message": "I died... find the exit and be free!", "name": "Toast", "createdAt": "2024-10-18T03:00:53.680Z" },
	{ "location": [9629.361328125, 3255.48315429688], "message": "I died in the woods, as I dreamed.", "name": "SteveFrench", "createdAt": "2024-10-18T03:31:35.960Z" },
	{ "location": [4931.7958984375, 4914.9658203125], "message": "Dang... gotta find the doghouse...", "name": "GummyWhere?", "createdAt": "2024-10-18T23:23:42.712Z" },
	{ "location": [5663.65771484375, 3150.02856445312], "message": "Gurgle! Stay away from the well!", "name": "Chatty", "createdAt": "2024-10-19T17:08:00.826Z" },
	{ "location": [4190.24365234375, 4965.02783203125], "message": "The geist is too fast for me :(", "name": "Goblin Man", "createdAt": "2024-10-20T00:32:36.195Z" },
	{ "location": [8611.763671875, 3768.7783203125], "message": "Curse these woods! I\'m all powerful!", "name": "Funny Guy", "createdAt": "2024-10-20T02:03:20.370Z" },
	{ "location": [11687.025390625, 928.52099609375], "message": "This geist means business.", "name": "Nathan F", "createdAt": "2024-10-20T04:50:56.376Z" },
	{ "location": [3837.75732421875, 3036.14990234375], "message": "The well... I hate that well.", "name": "Cokehead", "createdAt": "2024-10-20T04:55:09.414Z" }
]

var player_death_location: Vector2

func _ready() -> void:
	add_child(add_wisp_req)
	add_child(get_wisps_req)
	add_wisp_req.request_completed.connect(_add_wisp_req_completed)
	get_wisps_req.request_completed.connect(_get_wisps_req_completed)

func _process(_delta: float) -> void:
	pass

func addWisp(wisp: Dictionary) -> void:
	var body = JSON.stringify(wisp)
	var error = add_wisp_req.request("https://geistfeld.genya.games/wisps", [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error(error)
		return
	await add_wisp_req.request_completed

func getWisps() -> void:
	var error = get_wisps_req.request("https://geistfeld.genya.games/wisps")
	if error != OK:
		push_error(error)
		return
	await get_wisps_req.request_completed

func _add_wisp_req_completed(_result, response_code, _headers, _body) -> void:
	if response_code == 200:
		return
	else:
		print("Adding wisp failed :( ...")
		return

func _get_wisps_req_completed(_result, response_code, _headers, body) -> void:
	if response_code != 200:
		wisps = backup_wisps
		return
	var json = JSON.new()
	var body_string = body.get_string_from_utf8()
	json.parse(body_string)
	json.parse(json.data)
	var fetched_wisps = json.data
	wisps = fetched_wisps
