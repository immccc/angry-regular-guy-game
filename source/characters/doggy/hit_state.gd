extends "res://source/common/state/hit_state.gd"

const ANIMATION_HIT = "walk"
const ANIMATION_STAND = "stand"

const FORCE_Y_STEP = 5.0
const FORCE_X_STEP = 200.0

var STATE_CONSTANTS = preload("state_constants.gd")

func _init(id, node).(id, node):
	pass

func enter_into_state():
	.enter_into_state()
	initial_y = node.global_position.y
	sprite.flip_h = direction
	sprite.flip_v = true
	force = Vector2(300, -100)

func _get_next_state_when_stopped():
	if randi() % 2 < 1 :
		return STATE_CONSTANTS.STAND_STATE_ID
	else:
		return STATE_CONSTANTS.WALK_STATE_ID

func _update_on_air(delta):
	sprite.play(ANIMATION_HIT)

func _update_on_ground(delta):
	sprite.play(ANIMATION_STAND)

	force.x -= _get_force_x_step() * delta
	sprite.flip_v = false

func _get_force_y_step():
	return FORCE_Y_STEP

func _get_force_x_step():
	return FORCE_X_STEP