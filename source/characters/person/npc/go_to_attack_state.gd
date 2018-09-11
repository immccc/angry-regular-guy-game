extends "res://source/common/state/move_state.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const GO_TO_ATTACK_SPEED_SLOW = 250
const GO_TO_ATTACK_SPEED_FAST = 350

const DISTANCE_THRESHOLD = 50

var last_action_receiver_node_position

func _init(id, node).(id, node):
    pass

func enter_into_state():
    .enter_into_state()
    speed = rand_range(GO_TO_ATTACK_SPEED_SLOW, GO_TO_ATTACK_SPEED_FAST)

func process(delta):
    .process(delta)
    last_action_receiver_node_position = action_receiver_node.get_ref().global_position

func get_next_state():
    if !action_receiver_node.get_ref():
        return StateConstants.STAND_STATE_ID

    if action_receiver_node.get_ref().global_position.distance_to(node.global_position) <= DISTANCE_THRESHOLD or _is_path_finished():
        return StateConstants.STRIKE_STATE_ID
    else:
        return id

func _get_dest():
    var action_receiver_node_ref = action_receiver_node.get_ref()
    var dest = action_receiver_node_ref.global_position
    if node.global_position >= dest:
        dest += Vector2(action_receiver_node_ref.get_area().x / 2, 0)
    else:
        dest -= Vector2(action_receiver_node_ref.get_area().x / 2, 0)

    return path_finder.get_closest_point(path_finder.to_local(dest))


func _move(delta):
    if last_action_receiver_node_position != action_receiver_node.get_ref().global_position:
        _set_path()

    ._move(delta)
