extends "res://source/characters/person/person.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

var InputControlState = preload("input_control_state.gd")
var kick_area
var punch_area

func _ready():
    kick_area = $"KickArea"
    punch_area = $"PunchArea"

    _init_state_machine()

func flip():
    .flip()

    var sprite_rotation = 0.0
    if direction == DirectionType.LEFT:
        sprite_rotation = 180.0

    kick_area.rotation = deg2rad(sprite_rotation)
    punch_area.rotation = deg2rad(sprite_rotation)


func _init_state_machine():
    randomize()

    var node = $"."
    state_machine.add(InputControlState.new(StateConstants.INPUT_CONTROL_STATE_ID, node))
    state_machine.current_state_id = StateConstants.INPUT_CONTROL_STATE_ID

func _on_knock_timer_timeout():
    if state_machine.current_state_id == StateConstants.INPUT_CONTROL_STATE_ID:
        var input_control_state = state_machine.get(StateConstants.INPUT_CONTROL_STATE_ID)
        input_control_state.on_knock_timer_timeout()
