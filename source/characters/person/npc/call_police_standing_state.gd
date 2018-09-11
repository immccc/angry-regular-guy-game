extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_STAND = "call_police_standing"

var sprite

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func process(delta):
	sprite.play(ANIMATION_STAND)

func get_next_state():
	return id
