extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_FINE = "write_fine"
const MIN_FINE_TICKS = 10

const TOLERATED_DISTANCE_WITH_PROSECUTED = 150

var sprite
var fine_ticks = 0

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func enter_into_state():
	fine_ticks = 0

func process(delta):
	sprite.play(ANIMATION_FINE)

	_update_fine(delta)

func _update_fine(delta):
	fine_ticks += delta

func get_next_state():
	if fine_ticks > MIN_FINE_TICKS and rand_range(0, 100) <= 50:
		return StateConstants.LEAVE_ALONE_STATE_ID

	var action_receiver_ref = action_receiver_node.get_ref()
	if action_receiver_ref.global_position.distance_to(node.global_position) > TOLERATED_DISTANCE_WITH_PROSECUTED:
		if rand_range(0, 100) < 25:
			return StateConstants.SHOOTING_STATE_ID
		else:
			return StateConstants.GO_TO_FINE_STATE_ID

	return id
