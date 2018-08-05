extends Object

const StrikeType = preload("res://source/characters/person/strike_type.gd").StrikeType

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
var ready_to_knock = false

var kick_area
var punch_area

var strike_handler

var holding_object = false

func _init(node):
    _init_player_control(node)
    _init_strike_handler()

func _init_player_control(node):
    self.node = node
    sprite = node.get_node("Sprite")
    knock_timer = node.get_node("KnockTimer")
    kick_area = node.get_node("KickArea")
    punch_area = node.get_node("PunchArea")


func _init_strike_handler():
    var StrikeHandler = preload("res://source/characters/person/strike_handler.gd")

    var animations_per_strike_type = {
        StrikeType.PUNCH: ANIMATION_PUNCH,
        StrikeType.KICK: ANIMATION_KICK,
        StrikeType.KNOCK: ANIMATION_KNOCK
    }
    var climax_per_strike_type = {
        StrikeType.PUNCH: PUNCHING_LAST_FRAME,
        StrikeType.KICK: KICKING_LAST_FRAME,
        StrikeType.KNOCK: KNOCKING_LAST_FRAME
    }

    strike_handler = StrikeHandler.new(sprite, animations_per_strike_type, climax_per_strike_type)

func process_input(delta):
    _process_input_action()
    _process_input_strike()
    _process_input_for_walking(delta)

func _process_input_action():
    #TODO Make this work only when there is an object to be picked up
    if strike_handler.striking != false:
        return

    if Input.is_action_just_pressed(ACTION_ACTION):
        holding_object = true
    elif Input.is_action_just_released(ACTION_ACTION):
        holding_object = false

func _process_input_strike():
    if holding_object == true:
        return

    strike_handler.update()

    if strike_handler.striking:
        return

    if Input.is_action_just_pressed(ACTION_STRIKE_PUNCH):
        knock_timer.start()
        return

    if Input.is_action_just_released(ACTION_STRIKE_PUNCH):
        knock_timer.stop()
        ready_to_knock = false

        if ready_to_knock:
            strike_handler.start(StrikeType.KNOCK)
        else:
            strike_handler.start(StrikeType.PUNCH)

        return

    if Input.is_action_just_released(ACTION_STRIKE_KICK):
        strike_handler.start(StrikeType.KICK)
        return

func _process_input_for_walking(delta):
    if strike_handler.striking:
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

func _on_knock_timer_timeout():
    ready_to_knock = true

