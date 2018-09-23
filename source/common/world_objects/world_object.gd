extends Node2D

const DirectionType = preload("res://source/common/direction.gd").Direction

export (float) var altitude = 0.0
export (bool) var static_on_scene = false
export (bool) var flippable = false

var direction setget set_direction

onready var last_position = global_position

signal unfair_event_performed(offender, offended)

var associated_sprite

func _init(altitude = 0.0):
    self.altitude = altitude

func _ready():
    for node in get_children():
        if node is AnimatedSprite or node is Sprite:
            associated_sprite = node

        if node is VisibilityNotifier2D:
            _setup_object_disable_when_out_of_sight(node)

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

func get_area():
    print("Attempted to get area for object " + get_instance_id() + ", but it´s not defined")
    assert(false)

func _update_direction():
    if !flippable or associated_sprite == null:
        return

    if last_position.x != null and last_position.x != global_position.x:
        direction = sign(global_position.x - last_position.x)

    last_position = global_position
    flip()

func _setup_object_disable_when_out_of_sight(visibility_notifier):
    visibility_notifier.connect("screen_entered", self, "_on_visibility_change", [true])
    visibility_notifier.connect("screen_exited", self, "_on_visibility_change", [false])

func _on_visibility_change(is_visible):
    if !static_on_scene:
        set_process(true)
    elif is_visible:
        set_process(true)
    else:
        set_process(false)