extends "res://source/common/state/go_to_position.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_WAIT = "wait"

const GO_TO_POSITION_IN_QUEUE_SPEED_SLOW = 100
const GO_TO_POSITION_IN_QUEUE_SPEED_FAST = 200

const MIN_COOKING_TICKS = 100

const MIN_STOPPED_TIME = 1

var stopped_time = 0
var cooking_ticks = 0
var finishing = false

var min_position_x
var max_position_x

func enter_into_state():
    .enter_into_state()

    cooking_ticks = 0
    stopped_time = 0

    finishing = false

func _init(id, node, stand_node_path).(id, node):
    randomize()

    var stand_node = node.get_node(stand_node_path)
    min_position_x = stand_node.get_node("LeftLimit").global_position.x
    max_position_x = stand_node.get_node("RightLimit").global_position.x

func process(delta):
    _update_cooking_status(delta)

    if _is_path_finished():
        _process_when_stopped(delta)
    else:
        _process_when_moving(delta)

func get_next_state():
    if _is_path_finished():
        return _get_next_state()
    return id

func _update_cooking_status(delta):
    cooking_ticks += delta
    if cooking_ticks > MIN_COOKING_TICKS and rand_range(0, 100) < 25:
        finishing = true

func _process_when_stopped(delta):
    sprite.play(ANIMATION_WAIT)
    if finishing:
        return

    stopped_time += delta

    if stopped_time > MIN_STOPPED_TIME and randi() % 100 < 10:
        position_dest = _get_new_position()
        _set_path()

func _get_new_position():
    if finishing:
        return Vector2(min_position_x + (max_position_x - min_position_x) / 2.0, node.global_position_y)
    else:
        return Vector2(_get_random_x(), node.global_position.y)

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
