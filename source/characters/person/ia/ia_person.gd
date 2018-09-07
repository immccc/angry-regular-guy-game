extends "res://source/characters/person/person.gd"

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const StateConstants = preload("state_constants.gd")

const DirectionType = preload("res://source/common/direction.gd").Direction
const PersonalityAspect = preload("personality.gd").PersonalityAspect

const StandState = preload("stand_state.gd")
const WalkState = preload("walk_state.gd")
const HitState = preload("res://source/characters/person/ia/hit_state.gd")
const RunAwayState = preload("run_away_state.gd")

const MAX_INSTANCE_THRESHOLD = 2000

var personality = preload("personality.gd").new()

func _init():
    add_to_group("unfair_event_listeners")

func _ready():
    _setup_states()
    flippable = true

func _setup_states():
    randomize()

    state_machine.add(StandState.new(StateConstants.STAND_STATE_ID, node))
    state_machine.add(WalkState.new(StateConstants.WALK_STATE_ID, node))
    state_machine.add(HitState.new(CommonPersonStateConstants.HIT_STATE_ID, node))
    state_machine.add(RunAwayState.new(StateConstants.RUN_AWAY_STATE_ID, node))

    state_machine.current_state_id = StateConstants.STAND_STATE_ID

func _on_unfair_event_performed(offender, offended):
    var noticed_by_distance = _is_noticed_unfair_event_by_distance(offender)
    var noticed_by_direction = _is_noticed_by_looking_at_direction(offender)

    if noticed_by_distance and !noticed_by_direction:
        _set_reaction_when_not_looking()
    elif noticed_by_distance and noticed_by_direction:
        _set_reaction_when_looking(offender)

func _set_reaction_when_looking(offender):
    var personality_aspect = personality.react_to_external_problem()
    match personality_aspect:
        PersonalityAspect.COWARD:
            _run_away(offender)
        PersonalityAspect.RIGHTEOUS:
            print("I WILL CALL POLICE!!!")
        PersonalityAspect.AGGRESIVE:
            print("TASTE MY FIST, MADDAFAKKA!")
        PersonalityAspect.DISTRACTED:
            print("EITHER STOP FOR A MOMENT ON KEEP ON GOING")

func _set_reaction_when_not_looking():
    print("REACTION WHEN NOT LOOKING!")

func _is_noticed_by_looking_at_direction(offender):
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

func _is_noticed_unfair_event_by_distance(offender):
    var distance = offender.global_position.distance_to(node.global_position)
    distance = min(distance, MAX_INSTANCE_THRESHOLD)
    var probability_notice = 100 - (distance * 100 / MAX_INSTANCE_THRESHOLD)
    return randi() % 100 <= probability_notice


func _run_away(offender):
    var run_away_state = state_machine.get(StateConstants.RUN_AWAY_STATE_ID)
    run_away_state.offender = offender
    state_machine.change(StateConstants.RUN_AWAY_STATE_ID)
