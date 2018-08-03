extends "res://source/common/state/state.gd"

const ANIMATION_SMELL = "smell"
const MIN_SMELLING_TICKS = 3
const MAX_DISTANCE_WITH_HUMAN_TO_RUN_AFTER = 500

const STATE_CONSTANTS = preload("state_constants.gd")

var sprite
var smell_counter = 0
var player

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	player = node.get_node("/root").find_node("Player", true, false)

func process(delta):
	sprite.play(ANIMATION_SMELL)
	smell_counter += 1 * delta

func get_next_state():
	var change_state = smell_counter > MIN_SMELLING_TICKS and rand_range(0, 100) < 10

	if change_state == false:
		return id

	if node.global_position.distance_to(player.global_position) <= MAX_DISTANCE_WITH_HUMAN_TO_RUN_AFTER and rand_range(0, 100) < 75:
		return STATE_CONSTANTS.SEEK_HUMAN_STATE_ID

	if rand_range(0, 100) < 25:
		return STATE_CONSTANTS.PEE_STATE_ID

	if rand_range(0, 100) < 50:
		return STATE_CONSTANTS.STAND_STATE_ID

	return STATE_CONSTANTS.WALK_STATE_ID

func enter_into_state():
	smell_counter = 0
