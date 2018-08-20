extends Node2D

var altitude = 0.0
var direction

signal unfair_event_performed(offender, offended)

func _init(altitude = 0.0):
	self.altitude = altitude

func get_position_with_altitude():
	return position + Vector2(0, altitude)

func get_global_position_with_altitude():
	return global_position + Vector2(0, altitude)
