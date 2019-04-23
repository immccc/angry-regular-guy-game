extends "res://source/common/state/go_to_target_state.gd"

const DirectionType = preload("res://source/common/direction.gd").Direction
const StateConstants = preload("state_constants.gd")

const ANIMATION_WALK = "walk"
const ANIMATION_STAND = "stand"

const EVADE_ACTION_RECEIVER_SPEED = 100
const MIN_TICKS_WAITING_COP = 2

const Cop = preload("res://scenes/characters/person/cop.tscn")

var initial_distance_with_action_receiver
var last_position_action_receiver
var last_position_node
var ticks_waiting_cop = 0

func _init(id, node).(id, node):
    pass

func enter_into_state():
    last_position_action_receiver = action_receiver_node.get_ref().global_position
    last_position_node = node.global_position
    node.flippable = false
    ticks_waiting_cop = 0

    .enter_into_state()

    _request_cop()

func process(delta):
    .process(delta)

    ticks_waiting_cop += delta
    last_position_action_receiver = action_receiver_node.get_ref().global_position
    last_position_node = node.global_position
    node.direction = sign(action_receiver_node.get_ref().global_position.x - node.global_position.x)

func get_next_state():
    if(ticks_waiting_cop >= MIN_TICKS_WAITING_COP and rand_range(0, 100) <= 25):
        return StateConstants.RUN_AWAY_STATE_ID

    return .get_next_state()

func _anim():
    if last_position_node != node.global_position:
        sprite.play(ANIMATION_WALK)
    else:
        sprite.play(ANIMATION_STAND)

func _get_state_when_action_receiver_does_not_exist():
    return StateConstants.STAND_STATE_ID

func _get_state_when_action_receiver_reached():
    return id

func _get_speed_slow():
    return EVADE_ACTION_RECEIVER_SPEED

func _get_speed_fast():
    return EVADE_ACTION_RECEIVER_SPEED

func _get_extra_distance_from_action_receiver():
    if initial_distance_with_action_receiver == null:
        initial_distance_with_action_receiver = node.global_position - action_receiver_node.get_ref().global_position

    var delta_movement_action_receiver = last_position_action_receiver - action_receiver_node.get_ref().global_position

    return initial_distance_with_action_receiver - delta_movement_action_receiver

func _request_cop():
    var random_direction = [DirectionType.LEFT, DirectionType.RIGHT][randi() % 2]

    var world_object_generators = node.get_tree().get_nodes_in_group("world_object_generators")
    for world_object_generator in world_object_generators:
        world_object_generator.request_object_to_be_generated(Cop, random_direction, node, "set_offender_in_cop")

func _get_distance_threshold():
    return 200