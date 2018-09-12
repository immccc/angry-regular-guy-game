extends "res://source/characters/person/npc/npc_person.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const StateConstants = preload("state_constants.gd")

const DirectionType = preload("res://source/common/direction.gd").Direction
const PersonalityAspect = preload("personality.gd").PersonalityAspect

const HitState = preload("res://source/characters/person/hit_state.gd")
const FineState = preload("fine_state.gd")
const GoToFineState = preload("go_to_fine_state.gd")
const LeaveAloneState = preload("leave_alone_state.gd")
const ReprimandState = preload("reprimand_state.gd")
const ShootingState = preload("shooting_state.gd")

func _setup_states():
    randomize()

    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.add(FineState.new(StateConstants.FINE_STATE_ID, node))
    state_machine.add(GoToFineState.new(StateConstants.GO_TO_FINE_STATE_ID, node))
    state_machine.add(LeaveAloneState.new(StateConstants.LEAVE_ALONE_STATE_ID, node))
    state_machine.add(ReprimandState.new(StateConstants.REPRIMAND_STATE_ID, node))
    state_machine.add(ShootingState.new(StateConstants.REPRIMAND_STATE_ID, node))

    state_machine.current_state_id = StateConstants.STAND_STATE_ID

func _set_reaction_when_looking(offender):
    _react(offender, StateConstants.RUN_AWAY_STATE_ID)
 
func _set_reaction_when_not_looking():
    pass
