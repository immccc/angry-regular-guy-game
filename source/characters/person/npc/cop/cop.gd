extends "res://source/characters/person/npc/npc_person.gd"

const StateConstants = preload("state_constants.gd")

const HitState = preload("hit_state.gd")
const FineState = preload("fine_state.gd")
const GoToFineState = preload("go_to_fine_state.gd")
const LeaveAloneState = preload("leave_alone_state.gd")
const ReprimandState = preload("reprimand_state.gd")
const ShootingState = preload("shooting_state.gd")

func _setup_states():
    var node = $"."
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.add(FineState.new(StateConstants.FINE_STATE_ID, node))
    state_machine.add(GoToFineState.new(StateConstants.GO_TO_FINE_STATE_ID, node))
    state_machine.add(LeaveAloneState.new(StateConstants.LEAVE_ALONE_STATE_ID, node))
    state_machine.add(ReprimandState.new(StateConstants.REPRIMAND_STATE_ID, node))
    state_machine.add(ShootingState.new(StateConstants.SHOOTING_STATE_ID, node))

    assert(offender != null)
    _update_offender_in_states()

func _get_default_first_state():
    return StateConstants.GO_TO_FINE_STATE_ID

func _set_reaction_when_looking(discarded_personality_aspects = []):
    _update_offender_in_states()
    state_machine.change(StateConstants.GO_TO_FINE_STATE_ID)

func _set_reaction_when_not_looking():
    pass
