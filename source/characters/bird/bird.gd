extends "res://source/common/world_objects/stateful_world_object.gd"

const STATE_CONSTANTS = preload("state_constants.gd")

var FlyState = preload("fly_state.gd")

func _ready():

	randomize()

	var node = $"."

	state_machine.add(FlyState.new(STATE_CONSTANTS.FLY_STATE_ID, node))
	state_machine.current_state_id = STATE_CONSTANTS.FLY_STATE_ID

func _process(delta):
	state_machine.process(delta)

