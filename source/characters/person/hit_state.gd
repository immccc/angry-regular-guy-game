extends "res://source/common/state/hit_state.gd"

const ANIMATION_HIT = "walk"
const ANIMATION_STAND = "stand"

const FORCE_Y_STEP = 0.0
const FORCE_X_STEP = 200.0

func _init(id, node).(id, node):
	pass

func enter_into_state():
	.enter_into_state()
	initial_y = node.global_position.y

	force = Vector2(300, 0.0)

func _get_next_state_when_stopped():
	print("Hit State for person has not defined next state")
	assert(false)

func _update_on_ground(delta):
	sprite.play(ANIMATION_STAND)

	force.x -= _get_force_x_step() * delta
	sprite.flip_v = false

func _get_force_y_step():
	return FORCE_Y_STEP

func _get_force_x_step():
	return FORCE_X_STEP