extends "res://source/common/state/move_state.gd"

const StateConstants = preload("state_constants.gd")

const MOVE_SPEED = 100
const RUN_SPEED = 200

func _init(id, node).(id, node):
    pass

func get_next_state():
    if _is_path_finished() and rand_range(0, 10) < 2:
        return StateConstants.SMELL_STATE_ID
    else:
        return id

func enter_into_state():
    .enter_into_state()
    speed = rand_range(MOVE_SPEED, RUN_SPEED)

func _get_dest():
    var tile_map = node.get_node("/root").find_node("TileMap", true, false)

    var cells = tile_map.get_used_cells()
    var chosen_cell_position = tile_map.map_to_world(cells[randi() % cells.size()])

    return path_finder.get_closest_point(path_finder.to_local(chosen_cell_position))