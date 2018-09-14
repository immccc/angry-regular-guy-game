extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_REPRIMAND = "reprimand"
const MIN_REPRIMAND_TICKS = 7

const TOLERATED_DISTANCE_WITH_PROSECUTED = 150

var sprite
var reprimand_ticks = 0

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func enter_into_state():
    reprimand_ticks = 0

func process(delta):
    sprite.play(ANIMATION_REPRIMAND)

    _update_fine(delta)

func _update_fine(delta):
    reprimand_ticks += delta

func get_next_state():
    if reprimand_ticks > MIN_REPRIMAND_TICKS:
        return _get_random_continuing_state()

    var action_receiver_ref = action_receiver_node.get_ref()
    if action_receiver_ref.distance_to(node) > TOLERATED_DISTANCE_WITH_PROSECUTED:
        if rand_range(0, 100) < 25:
            return StateConstants.SHOOTING_STATE_ID
        else:
            return _get_random_continuing_state()

    return id

func _get_random_continuing_state():
    if rand_range(0, 100) <= 33:
        return StateConstants.LEAVE_ALONE_STATE_ID
    elif rand_range(0, 100) <= 50:
        return StateConstants.FINE_STATE_ID
    else:
        return StateConstants.REPRIMAND_STATE_ID
