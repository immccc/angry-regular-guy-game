extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_STAND = "call_cop_standing"

const MIN_DIALING_TICKS = 5

var sprite

var dialing_ticks = 0

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func enter_into_state():
    dialing_ticks = 0

func process(delta):
    sprite.play(ANIMATION_STAND)
    dialing_ticks += delta

func get_next_state():
    if(dialing_ticks >= MIN_DIALING_TICKS and rand_range(0, 100) > 25):
        return StateConstants.WAIT_FOR_COP_STATE_ID

    return id
