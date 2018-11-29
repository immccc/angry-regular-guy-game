extends Node

signal bothered_considerably_by(from)
signal bothered_totally_by(from)
signal bothered_considerably()
signal bothered_totally()

export (int) var considerable_bothered_level_total = 10
export (int) var maximum_bothered_level_total = 7
export (int) var considerable_bothered_level_per_each = 3
export (int) var maximum_bothered_level_per_each = 5
export (int) var bother_decreasing_factor = 1

var bothered_by = {}

func _ready():
    pass

func _process(delta):
    for bothering_element in bothered_by.keys():
        _notify_bothering(bothering_element)
        _decrease_bother_level(bothered_by[bothering_element], bother_decreasing_factor * delta)

func _notify_total_bothering():
    var total_bother_level = _get_total_bothered_level()
    if total_bother_level >= maximum_bothered_level_total:
        emit_signal("bothered_totally")
    elif total_bother_level >= considerable_bothered_level_total:
        emit_signal("bothered_considerably")


func _notify_bothering(bothering_element):
    var bother_level_for_element = bothered_by[bothering_element]
    if bother_level_for_element >= maximum_bothered_level_per_each:
        emit_signal("bothered_totally_by", bothering_element)
    elif bother_level_for_element >= considerable_bothered_level_per_each:
        emit_signal("bothered_considerably_by", bothering_element)

func _decrease_bother_level(from, amount):
    _update_bother_level(from, -amount)

func _get_total_bothered_level():
    var anger_levels = bothered_by.values()
    var total = 0
    for anger_level in anger_levels:
        total += anger_level
    return total

func _update_bother_level(from, amount):

    if !bothered_by.has(from):
        bothered_by[from] = 0

    var bother_factor = bothered_by[from] + amount

    if bother_factor <= 0:
        bothered_by.erase(from)
    else:
        bothered_by[from] = bother_factor

func _on_bothered_by(from, amount):
    _update_bother_level(from, amount)
