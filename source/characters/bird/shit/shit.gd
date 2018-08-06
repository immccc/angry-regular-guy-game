extends "res://source/common/world_objects/stateful_world_object.gd"

const STATE_CONSTANTS = preload("state_constants.gd")

var FallState = preload("fall_state.gd")
var HitState = preload("hit_state.gd")

func _ready():

	altitude = 2000 # TODO Change with real altitude

	randomize()

	var node = $"."

	state_machine.add(FallState.new(STATE_CONSTANTS.FALL_STATE_ID, node))
	state_machine.add(HitState.new(STATE_CONSTANTS.HIT_STATE_ID, node))

	state_machine.current_state_id = STATE_CONSTANTS.FALL_STATE_ID

	var fall_state = state_machine.get(STATE_CONSTANTS.FALL_STATE_ID)
	fall_state.altitude = altitude

func _on_hit_area_area_entered(area):
	if state_machine.current_state_id != STATE_CONSTANTS.HIT_STATE_ID:
		state_machine.change(STATE_CONSTANTS.HIT_STATE_ID)