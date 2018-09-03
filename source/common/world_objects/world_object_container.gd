extends YSort

#TODO make this container generic

var Doggy = preload("res://scenes/characters/doggy/doggy.tscn")
var Person = preload("res://scenes/characters/person/person.tscn")
var Bird = preload("res://scenes/characters/bird/bird.tscn")

var maximum_per_object_type = {
    Doggy: 3,
    Person: 5,
    Bird: 1
}

var currents_per_object_type = {
    Doggy: [],
    Person: [],
    Bird: []
}

func _get_max_of_type(world_object_class):
    return maximum_per_object_type[world_object_class]

func _on_removal_area_entered(object_to_remove):
    for object_type in currents_per_object_type.keys():
        for object in currents_per_object_type[object_type]:
            var is_object_in_currents = object == object_to_remove
            var is_object_child_of_currents = object.is_a_parent_of(object_to_remove)
            if  is_object_in_currents or is_object_child_of_currents:
                object.queue_free()
                currents_per_object_type[object_type].erase(object)

func _setup_other_objects_broadcast(instanced_object):
    for child in get_children():
        if child == instanced_object:
            continue

        if instanced_object.is_in_group("unfair_event_listeners") and child.is_in_group("unfair_event_victims"):
            child.connect("unfair_event_performed", instanced_object, "_on_unfair_event_performed")

        if instanced_object.is_in_group("unfair_event_victims") and child.is_in_group("unfair_event_listeners"):
            instanced_object.connect("unfair_event_performed", child, "_on_unfair_event_performed")

func _on_object_requested_to_be_added(object_node_type, object_position, direction):
    var currents_size = currents_per_object_type[object_node_type].size()
    var maximum = maximum_per_object_type[object_node_type]

    if currents_size < maximum:
        _create_object(object_node_type, object_position, direction)

func _create_object(object_node_type, object_position, direction):
    var instanced_object = object_node_type.instance()
    var global_position_before_adding_to_child = instanced_object.global_position #TODO Debug, remove!!!
    add_child(instanced_object, true)
    var global_position_after_adding_to_child = instanced_object.global_position #TODO Debug, remove!!!
    currents_per_object_type[object_node_type].append(instanced_object)
    instanced_object.global_position = object_position
    var global_position_after_setting_position = instanced_object.global_position #TODO Debug, remove!!!
    instanced_object.direction = direction
    _setup_other_objects_broadcast(instanced_object)