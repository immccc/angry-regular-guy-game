extends Node2D

signal object_requested_to_be_added(object_node_type, object_position)

#TODO in subclass
var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var Person = preload("res://scenes/characters/person/person.tscn")

func _ready():
    randomize()

func _process(delta):
    _generate_objects_randomly()

#TODO Implement in subclass
func _generate_objects_randomly():
    _generate_object_randomly(rand_range(0, 100), 5, Doggy)
    _generate_object_randomly(rand_range(0, 100), 2, Person)

func _generate_object_randomly(rand_factor, rand_threshold, object_class):
    if rand_factor < rand_threshold:
        var pos = _get_random_position()
        emit_signal("object_requested_to_be_added", object_class, pos)


func _get_random_position():
    var x = rand_range(global_position.x, global_position.x + global_scale.x)
    var y = rand_range(global_position.y, global_position.y + global_scale.y)
    return Vector2(x, y)