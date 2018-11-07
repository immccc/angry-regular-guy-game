extends "res://source/common/world_objects/world_object.gd"

export (String) var initial_state

var StateMachine = preload("res://source/common/state/state_machine.gd")
onready var state_machine = StateMachine.new()

func _ready():
	randomize()

	_setup_states()
	_setup_initial_state()

func _setup_initial_state():
	if initial_state == null or initial_state == "":
		state_machine.current_state_id = _get_default_first_state()
	else:
		state_machine.current_state_id = initial_state

func _get_default_first_state():
	print("Default first state needs to be defined for node %s" % name)
	assert(false)

func _process(delta):
	._process(delta)
	state_machine.process(delta)

func _setup_states():
	print("Stateful World Object must have states defined in _setup_states")
	assert(false)