extends "res://source/common/state/state.gd"

const STATE_CONSTANTS = preload("state_constants.gd")

const ANIMATION_PEE = "pee"
const MIN_PEEING_TICKS = 5

var sprite
var pee_counter = 0

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func process(delta):
	sprite.play(ANIMATION_PEE)
	pee_counter += 1 * delta

func get_next_state():
	var change_state = pee_counter > MIN_PEEING_TICKS and rand_range(0, 100) < 2

	if change_state == false:
		return id

	if rand_range(0, 100) < 25:
		return STATE_CONSTANTS.SMELL_STATE_ID

	if rand_range(0, 100) < 50:
		return STATE_CONSTANTS.STAND_STATE_ID

	return STATE_CONSTANTS.WALK_STATE_ID

func enter_into_state():
	pee_counter = 0
	sprite.flip_h = !sprite.flip_h
