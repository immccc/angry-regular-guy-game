extends Node2D

var altitude = 0.0
var direction

var positions_for_direction_calculation = []

signal unfair_event_performed(offender, offended)

func _init(altitude = 0.0):
	self.altitude = altitude

func _process(delta):
	_update_direction()

func get_position_with_altitude():
	return position + Vector2(0, altitude)

func get_global_position_with_altitude():
	return global_position + Vector2(0, altitude)

func _update_direction():
	positions_for_direction_calculation.append(global_position.x)
	if positions_for_direction_calculation.size() >= 2:
		var former_position = positions_for_direction_calculation.pop_back()
		var current_position = positions_for_direction_calculation.pop_back()
		positions_for_direction_calculation.clear()

		if former_position != current_position:
			direction = sign(current_position - former_position)