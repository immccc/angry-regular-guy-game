extends "res://source/characters/person/hit_state.gd"

const StateConstants = preload("state_constants.gd")

func _init(id, node).(id, node):
	pass

func _get_next_state_when_stopped():
	if randi() % 2 < 1 :
		return StateConstants.STAND_STATE_ID
	else:
		return StateConstants.WALK_STATE_ID
