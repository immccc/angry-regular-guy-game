extends "res://source/common/state/move_state.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const SPEED_SLOW = 250
const SPEED_HIGH = 350

const MIN_DISTANCE = 200
const MAX_DISTANCE = 400

func _init(id, node).(id, node):
    pass

func enter_into_state():
    .enter_into_state()
    speed = rand_range(SPEED_SLOW, SPEED_HIGH)

func get_next_state():
    if _is_path_finished():
        return [StateConstants.CALL_COP_WALKING_STATE_ID, StateConstants.CALL_COP_STANDING_STATE_ID][randi() % 2]

    return id

func _get_dest():
    var action_receiver_node_ref = action_receiver_node.get_ref()

    var direction_x = _get_random_direction()
    var direction_y = _get_random_direction()
    var dest_x = rand_range(MIN_DISTANCE, MAX_DISTANCE) * direction_x
    var dest_y = rand_range(MIN_DISTANCE, MAX_DISTANCE) * direction_y

    var dest = action_receiver_node_ref.global_position + Vector2(dest_x, dest_y)

    return path_finder.get_closest_point(path_finder.to_local(dest))

func _get_random_direction():
    return [DirectionType.LEFT, DirectionType.RIGHT][randi() % 2]
