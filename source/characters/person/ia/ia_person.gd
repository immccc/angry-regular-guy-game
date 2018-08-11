extends "res://source/characters/person/person.gd"

const StateConstants = preload("state_constants.gd")


var StandState = preload("stand_state.gd")
var WalkState = preload("walk_state.gd")

func _ready():

	randomize()

	var node = $"."

	state_machine.add(StandState.new(StateConstants.STAND_STATE_ID, node))
	state_machine.add(WalkState.new(StateConstants.WALK_STATE_ID, node))

	state_machine.current_state_id = StateConstants.STAND_STATE_ID