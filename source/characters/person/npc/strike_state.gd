extends "res://source/common/state/state.gd"

const StrikeType = preload("res://source/characters/person/strike_type.gd").StrikeType
const StateConstants = preload("state_constants.gd")

const STRENGTH_PER_STRIKE_TYPE = {
    StrikeType.PUNCH: 1,
    StrikeType.KICK: 1,
    StrikeType.KNOCK: 2
}

const PROBABILITIES_PER_STRIKE_TYPE = {
    StrikeType.PUNCH: 74,
    StrikeType.KICK: 25,
    StrikeType.KNOCK: 1
}

var strike_types = []

var strike_handler
var offender
var offender_position_last_strike

func _init(id, node).(id, node):
    randomize()

    strike_handler = node.get_node("StrikeHandler")
    assert(strike_handler != null)

    _fill_strike_types_by_probability()

func enter_into_state():
    _strike()

func process(delta):
    if strike_handler.is_striking():
        return

    if offender.global_position != offender_position_last_strike:
        return

    _strike()

func get_next_state():
    if !strike_handler.is_striking() and offender.global_position != offender_position_last_strike:
        return StateConstants.GO_TO_ATTACK_STATE_ID

    return id

func _fill_strike_types_by_probability():
    for strike_type in PROBABILITIES_PER_STRIKE_TYPE.keys():
        for index in range(PROBABILITIES_PER_STRIKE_TYPE[strike_type]):
            strike_types.append(strike_type)

func _get_strike_type():
    return strike_types[randi() % 100]

func _strike():
    var strike_type = _get_strike_type()
    strike_handler.start(strike_type, STRENGTH_PER_STRIKE_TYPE[strike_type], node.direction)
    offender_position_last_strike = offender.global_position
