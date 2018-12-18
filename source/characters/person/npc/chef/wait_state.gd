extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_SWAIT = "wait"

var sprite

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func process(delta):
	sprite.play(ANIMATION_SWAIT)

func get_next_state():
	return id
