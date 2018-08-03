extends Object

const WALKING_SPEED = 100
const STOPPED_SPEED = 0.0

const PUNCHING_LAST_FRAME = 2
const KICKING_LAST_FRAME = 2
const KNOCKING_LAST_FRAME = 2

const ANIMATION_STAND = "stand"
const ANIMATION_WALK = "walk"
const ANIMATION_PUNCH = "punch"
const ANIMATION_KICK = "kick"
const ANIMATION_KNOCK = "knock"
const ANIMATION_HOLD_AND_STAND = "hold_and_stand"
const ANIMATION_HOLD_AND_WALK = "hold_and_walk"

const ACTION_STRIKE_PUNCH = "strike_punch"
const ACTION_STRIKE_KICK = "strike_kick"
const ACTION_MOVE_LEFT = "move_left"
const ACTION_MOVE_RIGHT = "move_right"
const ACTION_MOVE_UP = "move_up"
const ACTION_MOVE_DOWN = "move_down"
const ACTION_ACTION = "action"

var node
var sprite
var knock_timer

var kick_area
var punch_area

var striking = false
var hitting = false
var ready_to_knock = false
var holding_object = false

func is_punching():
	return sprite.animation == ANIMATION_PUNCH

func is_punching_climax():
	return is_punching() and sprite.frame == PUNCHING_LAST_FRAME

func is_kicking():
	return sprite.animation == ANIMATION_KICK

func is_kicking_climax():
	return is_kicking() and sprite.frame == KICKING_LAST_FRAME

func is_knocking():
	return sprite.animation == ANIMATION_KNOCK

func is_knocking_climax():
	return is_knocking() and sprite.frame == KNOCKING_LAST_FRAME

func _init(node):
	self.node = node
	sprite = node.get_node("Sprite")
	knock_timer = node.get_node("KnockTimer")
	kick_area = node.get_node("KickArea")
	punch_area = node.get_node("PunchArea")
	
func process_input(delta):
	_process_input_action()
	_process_input_strike()
	_process_input_for_walking(delta)

func _process_input_action():
	#TODO Make this work only when there is an object to be picked up
	if striking != false:
		return
	
	if Input.is_action_just_pressed(ACTION_ACTION):
		holding_object = true
	elif Input.is_action_just_released(ACTION_ACTION):
		holding_object = false

func _process_input_strike():
	if holding_object == true:
		return

	if _is_hitting_finished():
		striking = false
		hitting = false
		ready_to_knock = false
		return

	if striking == false and Input.is_action_just_pressed(ACTION_STRIKE_PUNCH):
		knock_timer.start()
		return

	if striking == false and Input.is_action_just_released(ACTION_STRIKE_PUNCH):
		if ready_to_knock:
			_start_strike(ANIMATION_KNOCK)
		else:
			_start_strike(ANIMATION_PUNCH)
		return 

	if striking == false and Input.is_action_just_released(ACTION_STRIKE_KICK):
		_start_strike(ANIMATION_KICK)
		return 

	if is_punching_climax() or is_kicking_climax() or is_knocking_climax():
		hitting = true
		return
	

func _process_input_for_walking(delta):
	if striking != false:
		return

	var movement_x = STOPPED_SPEED
	var movement_y = STOPPED_SPEED

	if Input.is_action_pressed(ACTION_MOVE_LEFT):
		movement_x = -WALKING_SPEED * delta
		_set_character_flipped(true)
	elif Input.is_action_pressed(ACTION_MOVE_RIGHT):
		movement_x = WALKING_SPEED * delta
		_set_character_flipped(false)
	
	if Input.is_action_pressed(ACTION_MOVE_UP):
		movement_y = -WALKING_SPEED * delta
	elif Input.is_action_pressed(ACTION_MOVE_DOWN):
		movement_y = WALKING_SPEED * delta

	node.move_local_x(movement_x)
	node.move_local_y(movement_y)

	_animate_based_on_movement(movement_x, movement_y)

func _set_character_flipped(flip):
	sprite.flip_h = flip
	var sprite_rotation  = 0.0
	if flip == true:
		sprite_rotation = 180.0
	
	kick_area.rotation = deg2rad(sprite_rotation)
	punch_area.rotation = deg2rad(sprite_rotation)



func _animate_based_on_movement(movement_x, movement_y):
	var animation_stand = _get_animation_based_on_holding(ANIMATION_STAND, ANIMATION_HOLD_AND_STAND)
	var animation_walk = _get_animation_based_on_holding(ANIMATION_WALK, ANIMATION_HOLD_AND_WALK)

	if movement_x != STOPPED_SPEED:
		sprite.play(animation_walk)
	else:
		sprite.play(animation_stand)

func _get_animation_based_on_holding(default_animation, holding_animation):
	if holding_object == true:
		return holding_animation
	else:
		return default_animation

func _is_hitting_finished():
	return hitting == true and sprite.frame == 0

func _on_knock_timer_timeout():
	ready_to_knock = true

func _start_strike(strike_animation):
	striking = true
	sprite.play(strike_animation)
	knock_timer.stop()
	ready_to_knock = false
