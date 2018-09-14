extends Line2D

const DirectionType = preload("res://source/common/direction.gd").Direction

signal object_requested_to_be_added(object_node_type, object_position, direction, node_caller, prepare_object_to_be_added_method)

#TODO Workaround for getting rid of https://github.com/godotengine/godot/issues/20944
enum FakeDirection {LEFT = 1, RIGHT = 2}
export (FakeDirection) var direction_for_generated_objects

func _ready():
    add_to_group("world_object_generators")
    randomize()

func _process(delta):
    _generate_objects_randomly()

func request_object_to_be_generated(object_class, direction, node_caller = null, prepare_object_to_be_added_method = null):
    if !_get_allowed_object_classes().has(object_class):
        return

    if direction != _get_real_direction():
        return

    emit_signal("object_requested_to_be_added", object_class, _get_random_position(), direction, node_caller, prepare_object_to_be_added_method)

func _get_allowed_object_classes():
    print("Allowed object classes must be defined in world object generator")
    assert(false)

func _get_real_direction():
    if direction_for_generated_objects == 1:
        return DirectionType.LEFT
    elif direction_for_generated_objects == 2:
        return DirectionType.RIGHT


func _generate_objects_randomly():
    pass

func _generate_object_randomly(rand_factor, rand_threshold, object_class, pos = _get_random_position()):
    if rand_factor < rand_threshold:
        emit_signal("object_requested_to_be_added", object_class, pos, _get_real_direction(), null, null)

func _get_random_position():
    var x = to_global(get_point_position(0)).x
    var y_bound_1 = to_global(get_point_position(0)).y
    var y_bound_2 = to_global(get_point_position(1)).y
    return Vector2(x, rand_range(y_bound_1, y_bound_2))
