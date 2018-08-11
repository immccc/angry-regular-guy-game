extends YSort

#TODO make this container generic

var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var Person = preload("res://scenes/characters/person/person.tscn")

var maximum_per_object_type = {
    Doggy: 3,
    Person: 5
}

var currents_per_object_type = {
    Doggy: [],
    Person: []
}

func _get_max_of_type(world_object_class):
    return maximum_per_object_type[world_object_class]

func _on_object_requested_to_be_added(object_node_type, object_position):
    var currents_size = currents_per_object_type[object_node_type].size()
    var maximum = maximum_per_object_type[object_node_type]

    if currents_size < maximum:
        var instanced_object = object_node_type.instance()
        instanced_object.global_position = object_position
        add_child(instanced_object, true)
        currents_per_object_type[object_node_type].append(instanced_object)


func _on_removal_area_entered(object_to_remove):
    for object_type in currents_per_object_type.keys():
        for object in currents_per_object_type[object_type]:
            var is_object_in_currents = object == object_to_remove
            var is_object_child_of_currents = object.is_a_parent_of(object_to_remove)
            if  is_object_in_currents or is_object_child_of_currents:
                object.queue_free()
                currents_per_object_type[object_type].erase(object)
