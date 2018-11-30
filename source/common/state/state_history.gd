extends Object

const DEFAULT_MAX_STATES_IN_HISTORY = 10

var state_ids = PoolStringArray([])

var max_size = DEFAULT_MAX_STATES_IN_HISTORY

func add(state_id):
    state_ids.append(state_id)
    if state_ids.size() > max_size:
        state_ids.remove(0)

func get_last():
    if state_ids.size() == 0:
        return null
    return state_ids[state_ids.size() - 1]

func pop_front():
    if state_ids.size() == 0:
        return null
    var state_id = state_ids[state_ids.size() - 1]
    state_ids.remove(state_ids.size() - 1)
    return state_id
