extends "res://source/common/state/state.gd"

var sprite

var direction = 1

var force
var initial_y

func _init(id, node).(id, node):
    sprite = node.get_node("Sprite")
    assert(sprite != null)

func process(delta):
    _update(delta)

func _update(delta):

    force.y += _get_force_y_step()
    var new_position = node.global_position + Vector2(force.x * direction, force.y) * delta
    var ground_reached = new_position.y >=  initial_y

    if ground_reached:
        new_position.y = initial_y
        _update_on_ground(delta)
    else:
        _update_on_air(delta)

    node.global_position = new_position

func get_next_state():
    if force.x <= 0.0:
        return _get_next_state_when_stopped()
    return id

func enter_into_state():
    initial_y = node.global_position.y

func _get_next_state_when_stopped():
    pass

func _update_on_air(delta):
    pass

func _update_on_ground(delta):
    pass

func _get_force_y_step():
    pass

func _get_force_x_step():
    pass