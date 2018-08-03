extends Node2D

var altitude = 0.0

var StateMachine = preload("res://source/common/state/state_machine.gd")
onready var state_machine = StateMachine.new()

func _init(altitude = 0.0):
	self.altitude = altitude

func get_position_with_altitude():
	return position + Vector2(0, altitude)

func get_global_position_with_altitude():
	return global_position + Vector2(0, altitude)
	
func _process(delta):
	state_machine.process(delta)