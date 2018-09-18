extends "res://source/common/state/state.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")

const ANIMATION_SHOCK = "shock"

const MIN_SHOCK_TICKS = 2

var sprite

var shock_ticks = 0

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func enter_into_state():
    shock_ticks = 0

func process(delta):
    sprite.play(ANIMATION_SHOCK)
    shock_ticks += delta

func get_next_state():
    if shock_ticks >= MIN_SHOCK_TICKS:
        return CommonPersonStateConstants.DIE_STATE_ID

    return id