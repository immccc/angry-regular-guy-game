extends "walk_state.gd"

const STATE_CONSTANTS = preload("state_constants.gd")
const THRESHOLD_DISTANCE = 50
const MAX_ATTEMPTS_SEEKING = 4
const ANIMATION_WALK = "walk"

const RUN_FAST_SPEED = 600

var player
var available_attempts_seeking

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	path_finder = node.get_node("/root").find_node("PathFinder", true, false)
	player = node.get_node("/root").find_node("Player", true, false)

func get_next_state():
	if _is_player_reached():
		return STATE_CONSTANTS.PEE_STATE_ID

	if available_attempts_seeking > 0:
		return id

	if rand_range(0, 100) < 50:
		return STATE_CONSTANTS.STAND_STATE_ID

	return STATE_CONSTANTS.SMELL_STATE_ID


func _is_player_reached():

	return node.global_position.distance_to(player.global_position) <= THRESHOLD_DISTANCE

func enter_into_state():
	_set_path()

	speed = RUN_FAST_SPEED
	available_attempts_seeking = randi() % MAX_ATTEMPTS_SEEKING

func _set_path():
	var dest = path_finder.to_local(player.global_position)
	path = path_finder.get_simple_path(path_finder.to_local(node.global_position), dest)
	path.remove(0)


func _walk(delta):
	if _is_path_finished():
		if available_attempts_seeking > 0:
			_set_path()
			available_attempts_seeking -= 1
		else:
			return

	._walk(delta)


