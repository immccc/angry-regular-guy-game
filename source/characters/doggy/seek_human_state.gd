extends "walk_state.gd"

const StateConstants = preload("state_constants.gd")

const THRESHOLD_DISTANCE = 50
const MAX_ATTEMPTS_SEEKING = 4

const RUN_FAST_SPEED = 600

var player
var available_attempts_seeking

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")
    path_finder = node.get_node("/root").find_node("PathFinder", true, false)
    player = node.get_node("/root").find_node("Player", true, false)

func get_next_state():
    if _is_player_reached():
        return StateConstants.PEE_STATE_ID

    if available_attempts_seeking > 0:
        return id

    if rand_range(0, 100) < 50:
        return StateConstants.STAND_STATE_ID

    return StateConstants.SMELL_STATE_ID


func _is_player_reached():

    return node.global_position.distance_to(player.global_position) <= THRESHOLD_DISTANCE

func enter_into_state():
    .enter_into_state()

    speed = RUN_FAST_SPEED
    available_attempts_seeking = 1 + (randi() % MAX_ATTEMPTS_SEEKING)

func _get_dest():
    return path_finder.to_local(player.global_position)

func _move(delta):
    if _is_path_finished():
        available_attempts_seeking -= 1
        if available_attempts_seeking > 0:
            _set_path()
        else:
            return

    ._move(delta)


