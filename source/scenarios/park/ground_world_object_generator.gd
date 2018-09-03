extends "res://source/common/world_objects/world_object_generator.gd"

var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var Person = preload("res://scenes/characters/person/person.tscn")

func _generate_objects_randomly():
    _generate_object_randomly(rand_range(0, 100), .2, Doggy)
    _generate_object_randomly(rand_range(0, 100), .5, Person)
