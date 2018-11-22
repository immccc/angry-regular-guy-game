extends Node

signal on_being_bothered(from)
signal on_being_forgiving(from)

export (int) var considerable_bothered_level = 70
export (int) var maximum_bothered_level = 100

var bothered_by = {}

func _ready():
    pass

func _process(delta):
    pass

func increase_anger(from):
    _update_anger(from, 1)

func decrease_anger(from):
    _update_anger(from, -1)

func get_total_anger_level():
    var anger_levels = bothered_by.values()
    var total = 0
    for anger_level in anger_levels:
        total += anger_level
    return total

func _update_anger(from, amount):

    var bother_factor = 0
    if bothered_by.has(from):
        bother_factor = bothered_by[from] + amount

    if bother_factor <= 0:
        bothered_by.erase(from)
    else:
        bothered_by[from] = bother_factor

