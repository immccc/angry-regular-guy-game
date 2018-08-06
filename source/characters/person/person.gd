extends "res://source/common/world_objects/stateful_world_object.gd"

signal added_elements_to_be_hit(objects, strike_performer, strike_type)
signal removed_elements_to_be_hit(objects, strike_performer, strike_type)

const StrikeType = preload("res://source/characters/person/strike_type.gd").StrikeType

const ANIMATION_PUNCH = "punch"
const ANIMATION_KICK = "kick"
const ANIMATION_KNOCK= "knock"

const PUNCHING_LAST_FRAME = 2
const KICKING_LAST_FRAME = 2
const KNOCKING_LAST_FRAME = 2

onready var sprite = $Sprite

var objects_to_kick = Array()
var objects_to_punch = Array()

func _ready():
	_setup_strike_handler()

func get_width():
	sprite.get_frame(sprite.animation, sprite.frame).get_width()

func _on_kick_area_area_entered(area):
	objects_to_kick.append(area)
	emit_signal("added_elements_to_be_hit", [area], $".", StrikeType.KICK)

func _on_kick_area_area_exited(area):
	objects_to_kick.erase(area)
	emit_signal("removed_elements_to_be_hit", [area], $".", StrikeType.KICK)

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
