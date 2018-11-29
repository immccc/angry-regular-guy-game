const PersonalityAspect = preload("res://source/characters/person/npc/personality_aspects.gd").PersonalityAspect

const MAX_FACTOR_FOR_PERSONALITY_RANGE = 100

var personality_factors = {
}

func _init():
    _set_random_values()

func react_to_external_problem(discarded_personality_aspects = []):
    var selected_personality_aspect
    var max_factor = 0

    for personality_aspect in personality_factors.keys():
        if discarded_personality_aspects.find(personality_aspect) >= 0:
            continue

        var factor = personality_factors[personality_aspect]
        var random_remaining = randi() % (MAX_FACTOR_FOR_PERSONALITY_RANGE - factor + 1)
        if factor + random_remaining > max_factor:
            max_factor = factor + random_remaining
            selected_personality_aspect = personality_aspect
    return selected_personality_aspect

func _set_random_values():
    randomize()
    var personality_aspects_set = 0
    var remaining_factor_points = MAX_FACTOR_FOR_PERSONALITY_RANGE
    for personality_aspect in PersonalityAspect:
        var selected_factor
        if personality_aspects_set == PersonalityAspect.size() - 1:
            selected_factor = remaining_factor_points
        else:
            selected_factor = randi() % (remaining_factor_points + 1)

        personality_factors[PersonalityAspect[personality_aspect]] = selected_factor
