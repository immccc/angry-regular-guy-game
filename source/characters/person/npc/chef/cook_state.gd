extends "res://source/common/state/go_to_position.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_WAIT = "wait"

const GO_TO_POSITION_IN_QUEUE_SPEED_SLOW = 100
const GO_TO_POSITION_IN_QUEUE_SPEED_FAST = 200

const MIN_STOPPED_TIME = 1

var stopped_time = 0

var min_position_x
var max_position_x

func _init(id, node, stand_node_path).(id, node):
    randomize()

    var stand_node = node.get_node(stand_node_path)
    min_position_x = stand_node.get_node("LeftLimit").global_position.x
    max_position_x = stand_node.get_node("RightLimit").global_position.x

func process(delta):
    if _is_path_finished():
        _process_when_stopped(delta)
    else:
        _process_when_moving(delta)

func get_next_state():
    if _is_path_finished():
        return _get_next_state()
    return id

func _process_when_stopped(delta):
    stopped_time += delta

    sprite.play(ANIMATION_WAIT)

    if stopped_time > MIN_STOPPED_TIME and randi() % 100 < 10:
        position_dest = Vector2(_get_random_x(), node.global_position.y)
        _set_path()

func _process_when_moving(delta):
    stopped_time = 0
    _move(delta)
    ._anim()

func _get_random_x():
    var distance_from_min_x = abs(min_position_x - node.global_position.x)
    var distance_from_max_x = abs(max_position_x - node.global_position.x)

    var middle_x = min_position_x + (max_position_x - min_position_x) / 2.0
    if distance_from_max_x < distance_from_min_x:
        return rand_range(min_position_x, middle_x)
    else:
        return rand_range(middle_x, max_position_x)

func _get_next_state():
    return id

func _get_speed_slow():
    return GO_TO_POSITION_IN_QUEUE_SPEED_SLOW


func _get_speed_fast():
    return GO_TO_POSITION_IN_QUEUE_SPEED_FAST
