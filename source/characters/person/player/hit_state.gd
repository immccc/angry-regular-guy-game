extends "res://source/characters/person/hit_state.gd"

const StateConstants = preload("state_constants.gd")

func _init(id, node).(id, node):
	pass

func _get_next_state_when_stopped():
	return StateConstants.INPUT_CONTROL_STATE_ID
