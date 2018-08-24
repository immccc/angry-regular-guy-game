extends "res://source/common/state/state.gd"

const StrikeType = preload("res://source/characters/person/strike_type.gd").StrikeType

#TODO Move out of here
const KICK_STRENGTH = 1
const PUNCH_STRENGTH = 1
const KNOCK_STRENGTH = 2


const WALKING_SPEED = 100
const STOPPED_SPEED = 0.0

const ANIMATION_STAND = "stand"
const ANIMATION_WALK = "walk"
const ANIMATION_HOLD_AND_STAND = "hold_and_stand"
const ANIMATION_HOLD_AND_WALK = "hold_and_walk"

const ACTION_STRIKE_PUNCH = "strike_punch"
const ACTION_STRIKE_KICK = "strike_kick"
const ACTION_MOVE_LEFT = "move_left"
const ACTION_MOVE_RIGHT = "move_right"
const ACTION_MOVE_UP = "move_up"
const ACTION_MOVE_DOWN = "move_down"
const ACTION_ACTION = "action"

var sprite

var knock_timer
var ready_to_knock = false

var strike_handler

var holding_object = false

func _init(id, node).(id, node):

    sprite = node.get_node("Sprite")
    knock_timer = node.get_node("KnockTimer")
    strike_handler = node.get_node("StrikeHandler")

func process(delta):
    _process_input_action()
    _process_input_strike()
    _process_input_for_walking(delta)

func on_knock_timer_timeout():
    ready_to_knock = true

func _process_input_action():
    #TODO Make this work only when there is an object to be picked up
    if strike_handler.is_striking():
        return

    if Input.is_action_just_pressed(ACTION_ACTION):
        holding_object = true
    elif Input.is_action_just_released(ACTION_ACTION):
        holding_object = false

func _process_input_strike():
    if holding_object == true:
        return

    if strike_handler.is_striking():
        return

    if Input.is_action_just_pressed(ACTION_STRIKE_PUNCH):
        knock_timer.start()
        return

    if Input.is_action_just_released(ACTION_STRIKE_PUNCH):
        knock_timer.stop()


        if ready_to_knock:
            strike_handler.start(StrikeType.KNOCK, KNOCK_STRENGTH, node.direction)
        else:
            strike_handler.start(StrikeType.PUNCH, PUNCH_STRENGTH, node.direction)

        ready_to_knock = false
        return

    if Input.is_action_just_released(ACTION_STRIKE_KICK):
        strike_handler.start(StrikeType.KICK, KICK_STRENGTH, node.direction)
        return

func _process_input_for_walking(delta):
    if strike_handler.is_striking():
        return

    var movement_x = STOPPED_SPEED
    var movement_y = STOPPED_SPEED

    if Input.is_action_pressed(ACTION_MOVE_LEFT):
        movement_x = -WALKING_SPEED * delta
    elif Input.is_action_pressed(ACTION_MOVE_RIGHT):
        movement_x = WALKING_SPEED * delta

    if Input.is_action_pressed(ACTION_MOVE_UP):
        movement_y = -WALKING_SPEED * delta
    elif Input.is_action_pressed(ACTION_MOVE_DOWN):
        movement_y = WALKING_SPEED * delta

    node.move_local_x(movement_x)
    node.move_local_y(movement_y)

    _animate_based_on_movement(movement_x, movement_y)

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