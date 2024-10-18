extends Node

@onready var add_wisp_req := HTTPRequest.new()
@onready var get_wisps_req := HTTPRequest.new()
@onready var wisps: = []

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

func _add_wisp_req_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		return
	else:
		print("Adding wisp failed :( ...")
		return

func _get_wisps_req_completed(_result, response_code, _headers, body) -> void:
	if response_code != 200:
		wisps = []
		return
	var json = JSON.new()
	var body_string = body.get_string_from_utf8()
	json.parse(body_string)
	json.parse(json.data)
	var fetched_wisps = json.data
	wisps = fetched_wisps
