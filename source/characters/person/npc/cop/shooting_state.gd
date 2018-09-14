extends "res://source/common/state/state.gd"

const StateConstants = preload("state_constants.gd")

const ANIMATION_SHOOT = "shoot"

var sprite

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func enter_into_state():
    node.flippable = false

func process(delta):
    node.direction = sign(action_receiver_node.get_ref().global_position.x - node.global_position.x)
    sprite.play(ANIMATION_SHOOT)

func get_next_state():
    return id
