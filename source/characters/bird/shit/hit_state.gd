extends "res://source/common/state/state.gd"

const ANIMATION_HIT = "hit"

const LAST_FRAME = 2

var sprite
var delete_requested

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")

func process(delta):
	sprite.play(ANIMATION_HIT)
	if sprite.frame == LAST_FRAME:
		delete_requested = true

	if delete_requested:
		node.queue_free()

func enter_into_state():
	delete_requested = false