extends "res://source/common/state/go_to_target_state.gd"

const StateConstants = preload("state_constants.gd")

const GO_TO_ATTACK_SPEED_SLOW = 250
const GO_TO_ATTACK_SPEED_FAST = 350

func _init(id, node).(id, node):
    pass

func _get_state_when_action_receiver_does_not_exist():
    return StateConstants.LEAVE_ALONE_STATE_ID

func _get_state_when_action_receiver_reached():
    if rand_range(0, 100) <= 25:
        return StateConstants.REPRIMAND_STATE_ID

    return StateConstants.FINE_STATE_ID

func _get_speed_slow():
    return GO_TO_ATTACK_SPEED_SLOW

func _get_speed_fast():
    return GO_TO_ATTACK_SPEED_FAST
