extends "res://source/common/state/state.gd"

const ANIMATION_COMPLAINING = "complaining"

var sprite

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func process(delta):
    sprite.play(ANIMATION_COMPLAINING)
    node.direction = sign(action_receiver_node.get_ref().global_position.x - node.global_position.x)
