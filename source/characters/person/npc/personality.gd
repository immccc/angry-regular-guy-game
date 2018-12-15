extends Object

const PersonalityAspect = preload("res://source/characters/person/npc/personality_aspects.gd").PersonalityAspect

const MIN_FACTOR_FOR_PERSONALITY_RANGE = 0
const MAX_FACTOR_FOR_PERSONALITY_RANGE = 100

export(int, 0, 100) var preset_coward_factor
export(int, 0, 100) var preset_righteous_factor
export(int, 0, 100) var preset_aggressive_factor
export(int, 0, 100) var preset_distracted_factor

var personality_factors = {
}

func _ready():
    _set_personality_factors()

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

func _set_personality_factors():

    if _are_presets_defined():
        _set_personality_factors_from_presets()
    else:
        _set_personality_factors_random_values()

func _are_presets_defined():
    return _get_not_null_preset(preset_coward_factor) > 0 or _get_not_null_preset(preset_righteous_factor) + _get_not_null_preset(preset_aggressive_factor) + _get_not_null_preset(preset_distracted_factor) > 0

func _set_personality_factors_from_presets():
    var total_preset = _get_not_null_preset(preset_coward_factor) + _get_not_null_preset(preset_righteous_factor) + _get_not_null_preset(preset_aggressive_factor) + _get_not_null_preset(preset_distracted_factor)
    _add_normalized_preset_personality_factor(PersonalityAspect.COWARD, preset_coward_factor, total_preset)
    _add_normalized_preset_personality_factor(PersonalityAspect.RIGHTEOUS, preset_righteous_factor, total_preset)
    _add_normalized_preset_personality_factor(PersonalityAspect.AGGRESIVE, preset_coward_factor, total_preset)
    _add_normalized_preset_personality_factor(PersonalityAspect.DISTRACTED, preset_coward_factor, total_preset)

func _add_normalized_preset_personality_factor(personality_aspect, preset, total_preset):
    var non_null_preset = _get_not_null_preset(preset)
    personality_factors[personality_aspect] = MAX_FACTOR_FOR_PERSONALITY_RANGE * non_null_preset / total_preset

func _get_not_null_preset(preset):
    return preset if preset != null else 0

func _set_personality_factors_random_values():
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
