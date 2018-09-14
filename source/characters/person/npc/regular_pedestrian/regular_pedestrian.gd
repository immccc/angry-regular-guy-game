extends "res://source/characters/person/npc/npc_person.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const StandState = preload("stand_state.gd")
const WalkState = preload("walk_state.gd")
const HitState = preload("hit_state.gd")

const RunAwayState = preload("run_away_state.gd")

const GoToAttackState = preload("go_to_attack_state.gd")
const StrikeState = preload("strike_state.gd")

const GoToCallCopState = preload("go_to_call_cop_state.gd")
const CallCopWalkingState = preload("call_cop_walking_state.gd")
const CallCopStandingState = preload("call_cop_standing_state.gd")
const WaitForcopState = preload("wait_for_cop_state.gd")

func _init():
    add_to_group("unfair_event_listeners")

func _ready():
    _setup_states()
    flippable = true

func _setup_states():
    randomize()

    state_machine.add(StandState.new(StateConstants.STAND_STATE_ID, node))
    state_machine.add(WalkState.new(StateConstants.WALK_STATE_ID, node))
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))

    state_machine.add(RunAwayState.new(StateConstants.RUN_AWAY_STATE_ID, node))

    state_machine.add(GoToAttackState.new(StateConstants.GO_TO_ATTACK_STATE_ID, node))
    state_machine.add(StrikeState.new(StateConstants.STRIKE_STATE_ID, node))

    state_machine.add(GoToCallCopState.new(StateConstants.GO_TO_CALL_COP_STATE_ID, node))
    state_machine.add(CallCopWalkingState.new(StateConstants.CALL_COP_WALKING_STATE_ID, node))
    state_machine.add(CallCopStandingState.new(StateConstants.CALL_COP_STANDING_STATE_ID, node))
    state_machine.add(WaitForcopState.new(StateConstants.WAIT_FOR_COP_STATE_ID, node))

    state_machine.current_state_id = StateConstants.STAND_STATE_ID

func _get_state_by_personality_aspect(personality_aspect):
    return StateConstants.GO_TO_CALL_COP_STATE_ID
    # match personality_aspect:
    #     PersonalityAspect.COWARD:
    #         return StateConstants.RUN_AWAY_STATE_ID
    #     PersonalityAspect.RIGHTEOUS:
    #         return StateConstants.GO_TO_CALL_COP_STATE_ID
    #     PersonalityAspect.AGGRESIVE:
    #         return StateConstants.GO_TO_ATTACK_STATE_ID
    #     PersonalityAspect.DISTRACTED:
    #         return StateConstants.STAND_STATE_ID

func _set_reaction_when_not_looking():
    print("REACTION WHEN NOT LOOKING!")

func set_offender_in_cop(cop):
    cop.offender = offender

