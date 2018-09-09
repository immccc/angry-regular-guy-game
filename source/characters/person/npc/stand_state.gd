extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_STAND = "stand"

var sprite

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func process(delta):
	sprite.play(ANIMATION_STAND)

func get_next_state():
	if rand_range(0, 100) < 2:
		return StateConstants.WALK_STATE_ID
	else:
		return StateConstants.STAND_STATE_ID
