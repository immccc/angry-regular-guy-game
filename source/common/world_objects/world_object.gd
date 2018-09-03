extends Node2D

const DirectionType = preload("res://source/common/direction.gd").Direction

var altitude = 0.0
var direction setget set_direction

onready var last_position = global_position

signal unfair_event_performed(offender, offended)

export (bool) var flippable = false
var associated_sprite

func _init(altitude = 0.0):
    self.altitude = altitude

func _ready():
    for node in get_children():
        if node is AnimatedSprite or node is Sprite:
            associated_sprite = node
            return

func _process(delta):
    _update_direction()

func set_direction(new_direction):
    direction = new_direction
    last_position = global_position
    flip()
    
func flip():
    if direction == DirectionType.RIGHT:
        associated_sprite.flip_h = false
    elif direction == DirectionType.LEFT:
        associated_sprite.flip_h = true

func get_position_with_altitude():
    return position + Vector2(0, altitude)

func get_global_position_with_altitude():
    return global_position + Vector2(0, altitude)

func _update_direction():
    if !flippable or associated_sprite == null:
        return
    
    if last_position.x != null and last_position.x != global_position.x:
        direction = sign(global_position.x - last_position.x)

    last_position = global_position
    flip()
