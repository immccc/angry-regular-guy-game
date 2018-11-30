extends Object

const StateHistory = preload("state_history.gd")

var states = {}
var state_history = StateHistory.new()

var current_state_id

func clear():
    states = {}

func add(new_state):
    states[new_state.id] = new_state

func get(state_id):
	return states[state_id]

func change(state_id):
    state_history.add(current_state_id)
    current_state_id = state_id
    states[current_state_id].enter_into_state()

func revert_to_last_state():
    var last_state_id = state_history.pop_front()
    if last_state_id != null:
        change(last_state_id)
    else:
        #TODO Add logging!
        print("Warning! There is no last state in state machine to revert!")

func process(delta):
    var state = states[current_state_id]
    var next_state_id = state.get_next_state()
    if next_state_id != current_state_id:
        change(next_state_id)
        return
    state.process(delta)

