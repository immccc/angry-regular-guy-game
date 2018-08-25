extends "res://source/common/world_objects/world_object_generator.gd"

var Bird = preload("res://scenes/characters/bird/bird.tscn")

func _generate_objects_randomly():
    _generate_object_randomly(rand_range(0, 100), .2, Bird)
