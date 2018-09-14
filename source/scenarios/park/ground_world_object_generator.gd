extends "res://source/common/world_objects/world_object_generator.gd"

var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var RegularPedestrian = preload("res://scenes/characters/person/regular_pedestrian.tscn")
var Cop = preload("res://scenes/characters/person/cop.tscn")

func _get_allowed_object_classes():
    return [Doggy, RegularPedestrian, Cop]

func _generate_objects_randomly():
    _generate_object_randomly(rand_range(0, 100), .2, Doggy)
    _generate_object_randomly(rand_range(0, 100), .5, RegularPedestrian)
