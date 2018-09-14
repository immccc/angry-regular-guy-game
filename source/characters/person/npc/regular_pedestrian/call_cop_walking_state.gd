extends "res://source/common/state/move_state.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const ANIMATION_MOVE = "call_cop_walking"

const SPEED_SLOW = 150
const SPEED_HIGH = 250

const MIN_DISTANCE = 50
const MAX_DISTANCE = 200

const MIN_DIALING_TICKS = 5

var right_walking_limit
var left_walking_limit

var turning_counts = 0
var dialing_ticks = 0

func _init(id, node).(id, node):
    pass

func enter_into_state():
    var walking_limit = rand_range(MIN_DISTANCE, MAX_DISTANCE)
    right_walking_limit = node.global_position + Vector2(walking_limit, 0.0)
    left_walking_limit = node.global_position - Vector2(walking_limit, 0.0)
    speed = rand_range(SPEED_SLOW, SPEED_HIGH)

    turning_counts = 0
    dialing_ticks = 0

    _set_path()

func process(delta):
    sprite.play(ANIMATION_MOVE)
    _move(delta)
    dialing_ticks += delta

func _move(delta):
    if _is_path_finished():
        _set_path()

    ._move(delta)


func get_next_state():
    if(dialing_ticks >= MIN_DIALING_TICKS and rand_range(0, 100) > 25):
        return StateConstants.WAIT_FOR_COP_STATE_ID

    return id

func _get_dest():
    turning_counts += 1
    var dest =  [right_walking_limit, left_walking_limit][turning_counts % 2]
    return path_finder.get_closest_point(path_finder.to_local(dest))

