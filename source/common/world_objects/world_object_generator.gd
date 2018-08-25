extends Line2D

#const Direction = preload("res://source/common/direction.gd")

signal object_requested_to_be_added(object_node_type, object_position, direction)

#TODO Workaround for getting rid of https://github.com/godotengine/godot/issues/20944
enum FakeDirection {LEFT = 1, RIGHT = 2}
export (FakeDirection) var direction_for_generated_objects

func _get_real_direction():
    if direction_for_generated_objects == 1:
        return -1
    elif direction_for_generated_objects == 2:
        return 1

func _ready():
    randomize()

func _process(delta):
    _generate_objects_randomly()

func _generate_objects_randomly():
    pass

func _generate_object_randomly(rand_factor, rand_threshold, object_class, pos = _get_random_position()):
    if rand_factor < rand_threshold:
        emit_signal("object_requested_to_be_added", object_class, pos, _get_real_direction())


func _get_random_position():
    var x = to_global(get_point_position(0)).x
    var y_bound_1 = to_global(get_point_position(0)).y
    var y_bound_2 = to_global(get_point_position(1)).y
    return Vector2(x, rand_range(y_bound_1, y_bound_2))
