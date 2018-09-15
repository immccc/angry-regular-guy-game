extends "res://source/common/state/move_state.gd"

const DISTANCE_THRESHOLD = 50

var last_action_receiver_node_position

func _init(id, node).(id, node):
    speed = rand_range(_get_speed_slow(), _get_speed_fast())

func enter_into_state():
    .enter_into_state()

func process(delta):
    .process(delta)
    last_action_receiver_node_position = action_receiver_node.get_ref().global_position

func get_next_state():
    if !action_receiver_node.get_ref():
        return _get_state_when_action_receiver_does_not_exist()

    if action_receiver_node.get_ref().global_position.distance_to(node.global_position) <= DISTANCE_THRESHOLD:
        return _get_state_when_action_receiver_reached()
    else:
        return id

func _get_state_when_action_receiver_does_not_exist():
    print("State when action receiver does not exist must be defined")
    assert(false)

func _get_state_when_action_receiver_reached():
    print("State when action receiver has been reached must be defined")
    assert(false)

func _get_dest():
    var action_receiver_node_ref = action_receiver_node.get_ref()
    var dest = action_receiver_node_ref.global_position
    dest += _get_extra_distance_from_action_receiver()

    if node.global_position >= dest:
        dest += Vector2(action_receiver_node_ref.get_area().x / 2, 0)
    else:
        dest -= Vector2(action_receiver_node_ref.get_area().x / 2, 0)


    return path_finder.get_closest_point(path_finder.to_local(dest))

func _get_extra_distance_from_action_receiver():
    return Vector2(0.0, 0.0)

func _get_speed_slow():
    print("Slow speed must be defined")
    assert(false)

func _get_speed_fast():
    print("Fast speed must be defined")
    assert(false)

func _move(delta):
    if last_action_receiver_node_position != action_receiver_node.get_ref().global_position + _get_extra_distance_from_action_receiver():
        _set_path()

    ._move(delta)
