extends "res://source/characters/person/person.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const InputControlState = preload("input_control_state.gd")
const HitState = preload("hit_state.gd")

func _ready():
    kick_area = $"KickArea"
    punch_area = $"PunchArea"

    _setup_states()

func _setup_states():
    randomize()

    state_machine.add(InputControlState.new(StateConstants.INPUT_CONTROL_STATE_ID, node))
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.current_state_id = StateConstants.INPUT_CONTROL_STATE_ID

func _on_knock_timer_timeout():
    if state_machine.current_state_id == StateConstants.INPUT_CONTROL_STATE_ID:
        var input_control_state = state_machine.get(StateConstants.INPUT_CONTROL_STATE_ID)
        input_control_state.on_knock_timer_timeout()
