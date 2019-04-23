extends "res://source/common/state/move_state.gd"

var position_dest

func _init(id, node).(id, node):
    speed = rand_range(_get_speed_slow(), _get_speed_fast())

func enter_into_state():
    .enter_into_state()

func get_next_state():
    if _is_path_finished():
        return _get_next_state()
    return id

func _get_dest():
    return path_finder.get_closest_point(path_finder.to_local(position_dest))

func _get_speed_slow():
    push_error("Slow speed must be defined")
    assert(false)

func _get_speed_fast():
    push_error("Fast speed must be defined")
    assert(false)

func _get_next_state():
    push_error("Next state must be defined")
    assert(false)