extends Node2D

var currents_per_object_type = {}

func _ready():
    _init_currents_per_object_type()

func _init_currents_per_object_type():
    for object_type in _get_object_types():
        currents_per_object_type[object_type] = []

func _get_maximum_per_object_type():
    print("Maximum per object type Dictionary for distributor %s must be defined" % name)
    assert(false)

func _get_object_types():
    print("Object types must be defined for distributor %s must be defined" % name)
    assert(false)

func _get_containers_per_object_type():
    print("Containers per object type Dictionary must be defined for distributor %s" % name)
    assert(false)

func _on_removal_area_entered(object_to_remove):
    for object_type in currents_per_object_type.keys():
        for object in currents_per_object_type[object_type]:
            if _is_object_elegible_to_be_removed(object, object_to_remove):
                object.queue_free()
                currents_per_object_type[object_type].erase(object)

func _is_object_elegible_to_be_removed(object_candidate, object_to_remove):
    if object_candidate != object_to_remove and !object_candidate.is_a_parent_of(object_to_remove):
        return false

    if object_candidate.static_on_scene:
        return false

    return true

func _setup_other_objects_broadcast(instanced_object):
    if !instanced_object.is_in_group("unfair_event_listeners"):
        return

    var unfair_event_victims = get_tree().get_nodes_in_group("unfair_event_victims")
    for victim in unfair_event_victims:
        if victim != instanced_object:
            victim.connect("unfair_event_performed", instanced_object, "_on_unfair_event_performed")

func _on_static_object_requested_to_be_added(object_node_type, object_position, direction, node_caller = null, prepare_object_to_be_added_method = null):
    var object = _create_object(object_node_type, object_position, direction, node_caller, prepare_object_to_be_added_method)
    object.static_on_scene = true

func _on_object_requested_to_be_added(object_node_type, object_position, direction, node_caller = null, prepare_object_to_be_added_method = null):
    var amount_non_static_in_scene = _get_amount_non_static_in_scene_current_objects(object_node_type)
    var maximum = _get_maximum_per_object_type()[object_node_type]

    if amount_non_static_in_scene < maximum:
        _create_object(object_node_type, object_position, direction, node_caller, prepare_object_to_be_added_method)

func _get_amount_non_static_in_scene_current_objects(object_node_type):
    var amount = 0
    for object in currents_per_object_type[object_node_type]:
        if !object.static_on_scene:
            amount += 1

    return amount

func _create_object(object_node_type, object_position, direction, node_caller = null, prepare_object_to_be_added_method = null):
    var instanced_object = object_node_type.instance()

    if node_caller != null:
        node_caller.call(prepare_object_to_be_added_method, instanced_object)

    _get_containers_per_object_type()[object_node_type].add_child(instanced_object, true)
    currents_per_object_type[object_node_type].append(instanced_object)
    instanced_object.global_position = object_position
    instanced_object.direction = direction
    _setup_other_objects_broadcast(instanced_object)

    return instanced_object