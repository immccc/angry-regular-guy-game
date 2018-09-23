extends "res://source/common/world_objects/stateful_world_object.gd"

const StateConstants = preload("state_constants.gd")

var FlyState = preload("fly_state.gd")

func _ready():
    altitude = 500 + (randi() % 1500)

func _setup_states():
    var node = $"."

    state_machine.add(FlyState.new(StateConstants.FLY_STATE_ID, node))

func _get_default_first_state():
    return StateConstants.FLY_STATE_ID



