extends "res://source/common/world_objects/stateful_world_object.gd"

const StateConstants = preload("state_constants.gd")

var FallState = preload("fall_state.gd")
var HitState = preload("hit_state.gd")

func _ready():

	altitude = 2000 # TODO Change with real altitude

	randomize()

	var node = $"."

	state_machine.add(FallState.new(StateConstants.FALL_STATE_ID, node))
	state_machine.add(HitState.new(StateConstants.HIT_STATE_ID, node))

	state_machine.current_state_id = StateConstants.FALL_STATE_ID

	var fall_state = state_machine.get(StateConstants.FALL_STATE_ID)
	fall_state.altitude = altitude

func _on_hit_area_area_entered(area):
	if state_machine.current_state_id != StateConstants.HIT_STATE_ID:
		state_machine.change(StateConstants.HIT_STATE_ID)