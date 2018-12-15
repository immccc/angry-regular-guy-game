extends "res://source/characters/person/npc/npc_person.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const CommonNPCStateConstants = preload("res://source/characters/person/npc/states/state_constants.gd")
const StateConstants = preload("res://source/characters/person/npc/regular_pedestrian/state_constants.gd")

const DirectionType = preload("res://source/common/direction.gd").Direction

const StandState = preload("res://source/characters/person/npc/states/stand_state.gd")
const WalkState = preload("res://source/characters/person/npc/states/walk_state.gd")
const HitState = preload("res://source/characters/person/npc/states/hit_state.gd")
const ShockState = preload("res://source/characters/person/shock_state.gd")
const RunAwayState = preload("res://source/characters/person/npc/states/run_away_state.gd")

const GoToAttackState = preload("res://source/characters/person/npc/states/go_to_attack_state.gd")
const StrikeState = preload("res://source/characters/person/npc/states/strike_state.gd")

const GoToCallCopState = preload("res://source/characters/person/npc/states/go_to_call_cop_state.gd")
const CallCopWalkingState = preload("res://source/characters/person/npc/states/call_cop_walking_state.gd")
const CallCopStandingState = preload("res://source/characters/person/npc/states/call_cop_standing_state.gd")
const WaitForCopState = preload("res://source/characters/person/npc/states/wait_for_cop_state.gd")

const GoToPositionInQueueState = preload("go_to_position_in_queue_state.gd")

const ComplainingState = preload("res://source/characters/person/npc/states/complaining_state.gd")

func _init():
    add_to_group("unfair_event_listeners")

func _ready():
    ._ready()
    flippable = true

func _setup_states():
    randomize()

    node = $"."
    state_machine.add(StandState.new(CommonNPCStateConstants.STAND_STATE_ID, node))
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.add(ShockState.new(CommonPersonStateConstants.SHOCK_STATE_ID, node))

    state_machine.add(RunAwayState.new(CommonNPCStateConstants.RUN_AWAY_STATE_ID, node))

    state_machine.add(GoToAttackState.new(CommonNPCStateConstants.GO_TO_ATTACK_STATE_ID, node))
    state_machine.add(StrikeState.new(CommonNPCStateConstants.STRIKE_STATE_ID, node))

    state_machine.add(GoToCallCopState.new(CommonNPCStateConstants.GO_TO_CALL_COP_STATE_ID, node))
    state_machine.add(CallCopWalkingState.new(CommonNPCStateConstants.CALL_COP_WALKING_STATE_ID, node))
    state_machine.add(CallCopStandingState.new(CommonNPCStateConstants.CALL_COP_STANDING_STATE_ID, node))
    state_machine.add(WaitForCopState.new(CommonNPCStateConstants.WAIT_FOR_COP_STATE_ID, node))

    state_machine.add(ComplainingState.new(CommonNPCStateConstants.COMPLAINING_STATE_ID, node))

func _get_default_first_state():
    return CommonNPCStateConstants.STAND_STATE_ID

func _get_state_by_personality_aspect(personality_aspect):
    match personality_aspect:
        PersonalityAspect.COWARD:
            return StateConstants.RUN_AWAY_STATE_ID
        PersonalityAspect.RIGHTEOUS:
            return StateConstants.GO_TO_CALL_COP_STATE_ID
        PersonalityAspect.AGGRESIVE:
            return StateConstants.GO_TO_ATTACK_STATE_ID
        PersonalityAspect.DISTRACTED:
            return StateConstants.STAND_STATE_ID

func _set_reaction_when_not_looking():
    print("REACTION WHEN NOT LOOKING!")

func set_offender_in_cop(cop):
    cop.offender = offender

func _on_requested_move_to_position(pos):
    var state = state_machine.get(StateConstants.GO_TO_POSITION_IN_QUEUE_STATE_ID)
    state.position_dest = pos
    state_machine.change(StateConstants.GO_TO_POSITION_IN_QUEUE_STATE_ID)

func _on_considerably_bothered_by(bothering_element):
    var state = state_machine.get(StateConstants.COMPLAINING_STATE_ID)
    state.action_receiver_node = bothering_element
    state_machine.change(StateConstants.COMPLAINING_STATE_ID)
