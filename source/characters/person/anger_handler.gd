extends Node

signal bothered_considerably_by(element)
signal bothered_totally_by(element)
signal calmed_down_for(element)
signal bothered_considerably()
signal bothered_totally()
signal calmed_down()

enum BotherStatus {
    GLOBAL_CALMED_DOWN,
    GLOBAL_CONSIDERABLY_BOTHERED,
    GLOBAL_TOTALLY_BOTHERED,
    CALMED_DOWN_FOR_ELEMENT,
    BOTHERED_CONSIDERABLY_BY_ELEMENT,
    BOTHERED_TOTALLY_BY_ELEMENT
}

const SIGNALS_PER_BOTHER_STATUS = {
    GLOBAL_CALMED_DOWN: "calmed_down",
    GLOBAL_CONSIDERABLY_BOTHERED: "bothered_considerably",
    GLOBAL_TOTALLY_BOTHERED: "bothered_totally",
    CALMED_DOWN_FOR_ELEMENT: "calmed_down_for",
    BOTHERED_CONSIDERABLY_BY_ELEMENT: "bothered_considerably_by",
    BOTHERED_TOTALLY_BY_ELEMENT: "bothered_totally_by"
}

export (int) var considerable_bothered_level_total = 10
export (int) var maximum_bothered_level_total = 7
export (int) var considerable_bothered_level_per_each = 3
export (int) var maximum_bothered_level_per_each = 5
export (int) var bother_decreasing_factor = 0.05

var bothered_by = {}
var last_status_for = {}
var last_global_status = BotherStatus.GLOBAL_CALMED_DOWN

func _process(delta):
    for bothering_element in bothered_by.keys():
        _update_bothering(bothering_element, bother_decreasing_factor * delta)

    _update_global_bothering()


func _update_global_bothering():
    var total_bother_level = _get_total_bothered_level()
    if total_bother_level >= maximum_bothered_level_total:
        _update_last_status(BotherStatus.GLOBAL_TOTALLY_BOTHERED)
    elif total_bother_level >= considerable_bothered_level_total:
        _update_last_status(BotherStatus.GLOBAL_BOTHERED_CONSIDERABLY)
    else:
        _update_last_status(BotherStatus.GLOBAL_CALMED_DOWN)

func _update_bothering(bothering_element, amount):
    var bother_level_for_element = bothered_by[bothering_element]
    if bother_level_for_element >= maximum_bothered_level_per_each:
        _update_last_status(BotherStatus.BOTHERED_TOTALLY_BY_ELEMENT, bothering_element)
    elif bother_level_for_element >= considerable_bothered_level_per_each:
        _update_last_status(BotherStatus.BOTHERED_CONSIDERABLY_BY_ELEMENT, bothering_element)
    else:
        _update_last_status(BotherStatus.CALMED_DOWN_FOR_ELEMENT, bothering_element)

    _decrease_bother_level(bothering_element, amount)

func _update_last_status(new_status, source = null):
    var signal_to_emit = SIGNALS_PER_BOTHER_STATUS[new_status]
    if source == null and new_status != last_global_status:
        _emit_signal_if_applicable(last_global_status, new_status, signal_to_emit, source)
        last_global_status = new_status
    elif source != null and last_status_for.has(source) and last_status_for[source] != new_status:
        _emit_signal_if_applicable(last_status_for[source], new_status, signal_to_emit, source)
        last_status_for[source] = new_status

func _emit_signal_if_applicable(old_status, new_status, signal_to_emit, source):
    if old_status < new_status:
        emit_signal(signal_to_emit, source)

func _decrease_bother_level(bothering_element, amount):
    _update_bother_level(bothering_element, -amount)

func _get_total_bothered_level():
    var anger_levels = bothered_by.values()
    var total = 0
    for anger_level in anger_levels:
        total += anger_level
    return total

func _update_bother_level(from, amount):

    if !bothered_by.has(from):
        bothered_by[from] = 0
        last_status_for[from] = BotherStatus.CALMED_DOWN_FOR_ELEMENT

    var bother_factor = bothered_by[from] + amount

    if bother_factor <= 0:
        bothered_by.erase(from)
    else:
        bothered_by[from] = bother_factor

func _on_bothered_by(from, amount):
    _update_bother_level(from, amount)
