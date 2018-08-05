extends "res://source/common/state/state.gd"

const ANIMATION_HIT = "walk"
const ANIMATION_STAND = "stand"

const FORCE_Y = 5.0
const FORCE_X = 200.0

var STATE_CONSTANTS = preload("state_constants.gd")

var sprite

var direction = 1

var force
var initial_y

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	assert(sprite != null)

func process(delta):
	_update_shock(delta)

func _update_shock(delta):
	sprite.play(ANIMATION_HIT)

	force.y += FORCE_Y
	var new_position = node.global_position + Vector2(force.x * direction, force.y) * delta

	if new_position.y >= initial_y:
		sprite.play(ANIMATION_STAND)
		force.x -= FORCE_X * delta
		sprite.flip_v = false
		new_position.y = initial_y

	node.global_position = new_position

func get_next_state():
	if force.x <= 0.0:
		if randi() % 2 < 1 :
			return STATE_CONSTANTS.STAND_STATE_ID
		else:
			return STATE_CONSTANTS.WALK_STATE_ID

	return id

func enter_into_state():
	initial_y = node.global_position.y
	sprite.flip_h = direction
	sprite.flip_v = true
	force = Vector2(300, -100)
