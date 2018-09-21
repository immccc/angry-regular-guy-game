extends "res://source/common/world_objects/world_object_distributor.gd"

var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var RegularPedestrian = preload("res://scenes/characters/person/regular_pedestrian.tscn")
var Bird = preload("res://scenes/characters/bird/bird.tscn")
var Cop = preload("res://scenes/characters/person/cop.tscn")

var maximum_per_object_type = {
    Doggy: 3,
    RegularPedestrian: 5,
    Cop: 1,
    Bird: 1
}

onready var containers_per_object_type = {
    Doggy: $Ground,
    RegularPedestrian: $Ground,
    Cop: $Ground,
    Bird: $Air
}
func _get_maximum_per_object_type():
    return maximum_per_object_type

func _get_containers_per_object_type():
    return containers_per_object_type

func _get_object_types():
    return [Doggy, RegularPedestrian, Cop, Bird ]
