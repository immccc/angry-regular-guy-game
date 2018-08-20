extends Line2D

#const Direction = preload("res://source/common/direction.gd")


signal object_requested_to_be_added(object_node_type, object_position, direction)

#TODO Workaround for getting rid of https://github.com/godotengine/godot/issues/20944
enum FakeDirection {LEFT = 0, RIGHT = 2}
export (FakeDirection) var direction_for_generated_objects
func _get_real_direction():
    return direction_for_generated_objects - 1

#TODO in subclass
var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var Person = preload("res://scenes/characters/person/person.tscn")

func _ready():
    randomize()

func _process(delta):
    _generate_objects_randomly()

#TODO Implement in subclass
func _generate_objects_randomly():
    _generate_object_randomly(rand_range(0, 100), .2, Doggy)
    _generate_object_randomly(rand_range(0, 100), .2, Person)

func _generate_object_randomly(rand_factor, rand_threshold, object_class):
    if rand_factor < rand_threshold:
        var pos = _get_random_position()
        emit_signal("object_requested_to_be_added", object_class, pos, _get_real_direction())


func _get_random_position():
    var x = get_global_position().x
    var y_bound_1 = to_global(get_point_position(0)).y
    var y_bound_2 = to_global(get_point_position(1)).y
    return Vector2(x, rand_range(y_bound_1, y_bound_2))
