extends "res://source/characters/person/person.gd"

const StateConstants = preload("state_constants.gd")

const InputControlState = preload("input_control_state.gd")
const HitState = preload("hit_state.gd")
const ShockState = preload("res://source/characters/person/shock_state.gd")
const DieState = preload("res://source/characters/person/die_state.gd")

func _setup_states():
    randomize()

    node = $"."
    state_machine.add(InputControlState.new(StateConstants.INPUT_CONTROL_STATE_ID, node))
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.add(ShockState.new(CommonPersonStateConstants.SHOCK_STATE_ID, node))
    state_machine.add(DieState.new(CommonPersonStateConstants.DIE_STATE_ID, node))

func _get_default_first_state():
    return StateConstants.INPUT_CONTROL_STATE_ID

func _on_knock_timer_timeout():
    if state_machine.current_state_id == StateConstants.INPUT_CONTROL_STATE_ID:
        var input_control_state = state_machine.get(StateConstants.INPUT_CONTROL_STATE_ID)
        input_control_state.on_knock_timer_timeout()



