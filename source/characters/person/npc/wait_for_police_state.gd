extends "res://source/common/state/go_to_target_state.gd"

const StateConstants = preload("state_constants.gd")

const EVADE_ACTION_RECEIVER_SPEED = 100

var distance_with_action_receiver

func _init(id, node).(id, node):
    pass

func enter_into_state():
    .enter_into_state()

    node.flippable = false

func process(delta):
    .process(delta)
    node.direction = action_receiver_node.get_ref().global_position.x - node.global_position.x

func _get_state_when_action_receiver_does_not_exist():
    return StateConstants.STAND_STATE_ID

func _get_state_when_action_receiver_reached():
    return id

func _get_speed_slow():
    return EVADE_ACTION_RECEIVER_SPEED

func _get_speed_fast():
    return EVADE_ACTION_RECEIVER_SPEED

func _get_extra_distance_from_action_receiver():
    if distance_with_action_receiver == null:
        distance_with_action_receiver = node.global_position - action_receiver_node.get_ref().global_position

    return distance_with_action_receiver
