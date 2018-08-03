extends "res://source/common/state/state.gd"

const ANIMATION_FALL = "fall"
const ANIMATION_STAND = "stand"

const FORCE_Y_INCREMENT = 2.5
const INITIAL_FORCE_Y = 5.0
const MAX_FORCE_Y = 2000

var STATE_CONSTANTS = preload("state_constants.gd")

var sprite

var direction = 1

var force
var initial_y
var altitude


func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	_init_falling_force()

func process(delta):
	sprite.play(ANIMATION_FALL)

	node.global_position += force
	altitude -= force.y 

	force.y += FORCE_Y_INCREMENT * delta
	if force.y > MAX_FORCE_Y:
		force.y  = MAX_FORCE_Y

func get_next_state():
	if altitude <= 0.0:
		return STATE_CONSTANTS.HIT_STATE_ID
	return id

func enter_into_state():
	_init_falling_force()

func _init_falling_force():
	force = Vector2(0.0, INITIAL_FORCE_Y)


