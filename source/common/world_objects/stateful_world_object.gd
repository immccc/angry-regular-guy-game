extends "res://source/common/world_objects/world_object.gd"


var StateMachine = preload("res://source/common/state/state_machine.gd")
onready var state_machine = StateMachine.new()

func _process(delta):
	._process(delta)
	state_machine.process(delta)