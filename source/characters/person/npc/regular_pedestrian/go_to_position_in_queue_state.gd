extends "res://source/common/state/go_to_position.gd"

const StateConstants = preload("state_constants.gd")

const GO_TO_POSITION_IN_QUEUE_SPEED_SLOW = 100
const GO_TO_POSITION_IN_QUEUE_SPEED_FAST = 200

func _init(id, node).(id, node):
    pass

func _get_next_state():
    return StateConstants.WAIT_IN_QUEUE_STATE_ID

func _get_speed_slow():
    return GO_TO_POSITION_IN_QUEUE_SPEED_SLOW


func _get_speed_fast():
    return GO_TO_POSITION_IN_QUEUE_SPEED_FAST
