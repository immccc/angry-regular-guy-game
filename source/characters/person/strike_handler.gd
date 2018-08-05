extends Node

const StrikeType = preload("strike_type.gd").StrikeType

var striking = false
var hitting = false

var sprite
var animations_per_strike_type
var climax_per_strike_type

func _init(sprite, animations_per_strike_type, climax_per_strike_type):
    self.sprite = sprite
    self.animations_per_strike_type = animations_per_strike_type
    self.climax_per_strike_type = climax_per_strike_type

func start(strike_type):
	striking = true
	sprite.play(animations_per_strike_type[strike_type])

func update():
    if _is_hitting_finished():
        striking = false
        hitting = false

    elif _is_hitting_started():
        hitting = true

func _is_hitting_finished():
    return hitting and sprite.frame == 0

func _is_hitting_started():
    for strike_type in StrikeType:
        if _is_striking_climax(StrikeType[strike_type]):
            return true

    return false

func _is_striking(strike_type):
    return sprite.animation == animations_per_strike_type[strike_type]

func _is_striking_climax(strike_type):
    return _is_striking(strike_type) and sprite.frame == climax_per_strike_type[strike_type]
