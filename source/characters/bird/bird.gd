extends "res://source/common/world_objects/stateful_world_object.gd"

const StateConstants = preload("state_constants.gd")

var FlyState = preload("fly_state.gd")

func _ready():
    ._ready()

    randomize()
    altitude = 500 + (randi() % 1500)
    _setup_state_machine()

func _setup_state_machine():
    var node = $"."

    state_machine.add(FlyState.new(StateConstants.FLY_STATE_ID, node))
    state_machine.current_state_id = StateConstants.FLY_STATE_ID



