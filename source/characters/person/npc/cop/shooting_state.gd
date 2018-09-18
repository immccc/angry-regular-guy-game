extends "res://source/common/state/state.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const StateConstants = preload("state_constants.gd")

const ANIMATION_SHOOT = "shoot"

var sprite
var shot_done

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")

func enter_into_state():
    node.flippable = false
    shot_done = false

func process(delta):
    node.direction = sign(action_receiver_node.get_ref().global_position.x - node.global_position.x)
    sprite.play(ANIMATION_SHOOT)

    _shock_action_receiver_if_applicable()

func get_next_state():
    return id

func _shock_action_receiver_if_applicable():
    var sprite_frames = sprite.frames
    var frame_count = sprite_frames.get_frame_count(ANIMATION_SHOOT)
    var current_frame = sprite.frame

    if !shot_done and current_frame == frame_count - 1:
        action_receiver_node.get_ref().state_machine.change(CommonPersonStateConstants.SHOCK_STATE_ID)
        shot_done = true
