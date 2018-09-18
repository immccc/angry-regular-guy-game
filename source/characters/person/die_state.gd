extends "res://source/common/state/state.gd"

const ANIMATION_DIE = "die"

var sprite

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func process(delta):
    sprite.play(ANIMATION_DIE)

