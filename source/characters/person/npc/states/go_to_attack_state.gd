extends "res://source/common/state/go_to_target_state.gd"

const StateConstants = preload("state_constants.gd")

const GO_TO_ATTACK_SPEED_SLOW = 250
const GO_TO_ATTACK_SPEED_FAST = 350

func _init(id, node).(id, node):
    pass

func _get_state_when_action_receiver_does_not_exist():
    return StateConstants.STAND_STATE_ID

func _get_state_when_action_receiver_reached():
    return StateConstants.STRIKE_STATE_ID

func _get_speed_slow():
    return GO_TO_ATTACK_SPEED_SLOW

func _get_speed_fast():
    return GO_TO_ATTACK_SPEED_FAST
