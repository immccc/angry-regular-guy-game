extends "res://source/common/world_objects/stateful_world_object.gd"

signal added_elements_to_be_hit(objects, strike_performer, strike_type)
signal removed_elements_to_be_hit(objects, strike_performer, strike_type)

const CommonPersonStateConstants = preload("res://source/characters/person/common_person_state_constants.gd")
const StrikeType = preload("res://source/characters/person/strike_type.gd").StrikeType

const ANIMATION_PUNCH = "punch"
const ANIMATION_KICK = "kick"
const ANIMATION_KNOCK= "knock"

const PUNCHING_LAST_FRAME = 2
const KICKING_LAST_FRAME = 2
const KNOCKING_LAST_FRAME = 2

onready var node = $"."
onready var sprite = $Sprite

func _ready():
	_setup_strike_handler()

func get_area():
    var shape = $"DamageArea/CollisionShape2D".shape
    return shape.get_extents() * 2

func _on_kick_area_area_entered(area):
	emit_signal("added_elements_to_be_hit", [area], $".", StrikeType.KICK)

func _on_kick_area_area_exited(area):
	emit_signal("removed_elements_to_be_hit", [area], $".", StrikeType.KICK)

func _on_punch_area_area_entered(area):
    emit_signal("added_elements_to_be_hit", [area], $".", StrikeType.PUNCH)

func _on_punch_area_area_exited(area):
    emit_signal("removed_elements_to_be_hit", [area], $".", StrikeType.PUNCH)

func _setup_strike_handler():
    var animations_per_strike_type = {
        StrikeType.PUNCH: ANIMATION_PUNCH,
        StrikeType.KICK: ANIMATION_KICK,
        StrikeType.KNOCK: ANIMATION_KNOCK
    }
    var climax_per_strike_type = {
        StrikeType.PUNCH: PUNCHING_LAST_FRAME,
        StrikeType.KICK: KICKING_LAST_FRAME,
        StrikeType.KNOCK: KNOCKING_LAST_FRAME
    }

    var strike_handler = $StrikeHandler
    strike_handler.setup(animations_per_strike_type, climax_per_strike_type)

    connect("added_elements_to_be_hit", strike_handler, "_on_added_elements_to_be_hit")
    connect("removed_elements_to_be_hit", strike_handler, "_on_removed_elements_to_be_hit")

#TODO Probably this could be refactored to avoid duplicating this method throughout each world object
func _on_damage_received(from, strength, direction):
    if state_machine.current_state_id != CommonPersonStateConstants.HIT_STATE_ID:
        var hit_state = state_machine.get(CommonPersonStateConstants.HIT_STATE_ID)
        hit_state.direction = direction
        state_machine.change(CommonPersonStateConstants.HIT_STATE_ID)
        emit_signal("unfair_event_performed", from, node)