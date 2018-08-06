extends "res://source/common/world_objects/stateful_world_object.gd"

const STATE_CONSTANTS = preload("state_constants.gd")


var StandState = preload("stand_state.gd")
var WalkState = preload("walk_state.gd")
var SmellState = preload("smell_state.gd")
var PeeState = preload("pee_state.gd")
var HitState = preload("hit_state.gd")
var SeekHumanState = preload("seek_human_state.gd")

func _ready():

	randomize()

	var node = $"."

	state_machine.add(StandState.new(STATE_CONSTANTS.STAND_STATE_ID, node))
	state_machine.add(WalkState.new(STATE_CONSTANTS.WALK_STATE_ID, node))
	state_machine.add(SmellState.new(STATE_CONSTANTS.SMELL_STATE_ID, node))
	state_machine.add(PeeState.new(STATE_CONSTANTS.PEE_STATE_ID, node))
	state_machine.add(HitState.new(STATE_CONSTANTS.HIT_STATE_ID, node))
	state_machine.add(SeekHumanState.new(STATE_CONSTANTS.SEEK_HUMAN_STATE_ID, node))

	state_machine.current_state_id = STATE_CONSTANTS.STAND_STATE_ID

func _on_kick_area_hit_received(strength, direction):
	if state_machine.current_state_id != STATE_CONSTANTS.HIT_STATE_ID:
		var hit_state = state_machine.get(STATE_CONSTANTS.HIT_STATE_ID)
		hit_state.direction = direction
		state_machine.change(STATE_CONSTANTS.HIT_STATE_ID)
