extends Node

const StrikeType = preload("strike_type.gd").StrikeType

var node
var sprite

var strike_type
var strength
var direction

var strike_to_be_finished = false

var animations_per_strike_type
var climax_per_strike_type
var objects_to_hit_per_strike_type = {}

var animation_before_strike

export var y_distance_threshold = 0

func _ready():
    node = $".."
    sprite = $"../Sprite"
    assert(sprite != null)

func _process(delta):
    assert(animations_per_strike_type != null)
    assert(climax_per_strike_type != null)

    _restore_previous_state_if_needed()
    _update_striking_if_needed()

func setup(animations_per_strike_type, climax_per_strike_type):
    self.animations_per_strike_type = animations_per_strike_type
    self.climax_per_strike_type = climax_per_strike_type

func start(strike_type, strength, direction):
    animation_before_strike = sprite.animation
    sprite.play(animations_per_strike_type[strike_type])
    self.strike_type = strike_type
    self.strength = strength
    self.direction = direction

func is_striking():
    return animation_before_strike != null

func _restore_previous_state_if_needed():
    if strike_type == null and animation_before_strike != null:
        sprite.play(animation_before_strike)
        animation_before_strike = null

    if strike_to_be_finished:
        strike_to_be_finished = false
        strike_type = null

func _update_striking_if_needed():
    if strike_type == null:
        return

    if _is_striking_climax():
        _hit_objects(strike_type)
        strike_to_be_finished = true


func _hit_objects(strike_type):
    if objects_to_hit_per_strike_type == null:
        return
    if !objects_to_hit_per_strike_type.has(strike_type):
        return
    for object in objects_to_hit_per_strike_type[strike_type]:
        if abs(object.global_position.y - node.global_position.y) <= y_distance_threshold:
            object.emit_signal("damage_inflicted", node, strength, direction)

func _is_striking_climax():
    return is_striking() and sprite.frame == climax_per_strike_type[strike_type]


func _on_added_elements_to_be_hit(objects, strike_performer, strike_type):
    if !objects_to_hit_per_strike_type.has(strike_type):
        objects_to_hit_per_strike_type[strike_type] = objects.duplicate()
    else:
        for object in objects:
            objects_to_hit_per_strike_type[strike_type].append(object)

func _on_removed_elements_to_be_hit(objects, strike_performer, strike_type):
    if !objects_to_hit_per_strike_type.has(strike_type):
        return

    for object in objects_to_hit_per_strike_type[strike_type]:
        objects_to_hit_per_strike_type[strike_type].erase(object)
