extends "res://source/characters/person/person.gd"

const PersonalityAspect = preload("res://source/characters/person/npc/personality_aspects.gd").PersonalityAspect

const MAX_NOTICE_DISTANCE_THRESHOLD = 2000

var personality = preload("personality.gd").new()
var offender = null

func _init():
    add_to_group("unfair_event_listeners")

func _ready():
    flippable = true

func _on_unfair_event_performed(offender, offended):
    self.offender = offender

    var noticed_by_distance = _is_noticed_unfair_event_by_distance()
    var noticed_by_direction = _is_noticed_by_looking_at_direction()

    if noticed_by_distance and !noticed_by_direction:
        _set_reaction_when_not_looking()
    elif noticed_by_distance and noticed_by_direction:
        _set_reaction_when_looking()

func _set_reaction_when_looking(discarded_personality_aspects = []):
    var personality_aspect = personality.react_to_external_problem(discarded_personality_aspects)

    _update_offender_in_states()
    state_machine.change(_get_state_by_personality_aspect(personality_aspect))


func _set_reaction_when_not_looking():
    pass

func _get_state_by_personality_aspect(personality_aspect):
    print("State by personality aspect should be defined in NPC Person")
    assert(false)

func _is_noticed_by_looking_at_direction():
    var node_overtaking_offender = node.global_position.x > offender.global_position.x
    var noticed_based_on_distraction = randi() % 100 <= 100 - personality.personality_factors[PersonalityAspect.DISTRACTED]
    if node_overtaking_offender and node.direction == DirectionType.LEFT:
        return true
    elif node_overtaking_offender and node.direction == DirectionType.LEFT:
        return noticed_based_on_distraction
    elif !node_overtaking_offender and node.direction == DirectionType.RIGHT:
        return true
    elif !node_overtaking_offender and node.direction == DirectionType.RIGHT:
        return noticed_based_on_distraction
    else:
        return false

func _is_noticed_unfair_event_by_distance():
    var distance = offender.global_position.distance_to(node.global_position)
    distance = min(distance, MAX_NOTICE_DISTANCE_THRESHOLD)
    var probability_notice = 100 - (distance * 100 / MAX_NOTICE_DISTANCE_THRESHOLD)
    return randi() % 100 <= probability_notice


func _update_offender_in_states():
    for state in state_machine.states.values():
        state.action_receiver_node = offender
