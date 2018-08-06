extends "res://source/common/world_objects/stateful_world_object.gd"

const StateConstants = preload("state_constants.gd")


var StandState = preload("stand_state.gd")
var WalkState = preload("walk_state.gd")
var SmellState = preload("smell_state.gd")
var PeeState = preload("pee_state.gd")
var HitState = preload("hit_state.gd")
var SeekHumanState = preload("seek_human_state.gd")

func _ready():

	randomize()

	var node = $"."

	state_machine.add(StandState.new(StateConstants.STAND_STATE_ID, node))
	state_machine.add(WalkState.new(StateConstants.WALK_STATE_ID, node))
	state_machine.add(SmellState.new(StateConstants.SMELL_STATE_ID, node))
	state_machine.add(PeeState.new(StateConstants.PEE_STATE_ID, node))
	state_machine.add(HitState.new(StateConstants.HIT_STATE_ID, node))
	state_machine.add(SeekHumanState.new(StateConstants.SEEK_HUMAN_STATE_ID, node))

	state_machine.current_state_id = StateConstants.STAND_STATE_ID

func _on_kick_area_hit_received(strength, direction):
	if state_machine.current_state_id != StateConstants.HIT_STATE_ID:
		var hit_state = state_machine.get(StateConstants.HIT_STATE_ID)
		hit_state.direction = direction
		state_machine.change(StateConstants.HIT_STATE_ID)
