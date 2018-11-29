extends Object

var states = {}

var current_state_id

func clear():
    states = {}

func add(new_state):
    states[new_state.id] = new_state

func get(state_id):
	return states[state_id]

func change(state_id):
    current_state_id = state_id
    states[current_state_id].enter_into_state()

func process(delta):
    var state = states[current_state_id]
    var next_state_id = state.get_next_state()
    if next_state_id != current_state_id:
        change(next_state_id)
        return
    state.process(delta)

