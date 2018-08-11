extends "res://source/common/state/move_state.gd"

const STATE_CONSTANTS = preload("state_constants.gd")

const MOVE_SPEED = 100
const RUN_SPEED = 200

func _init(id, node).(id, node):
    pass

func get_next_state():
        return id

func enter_into_state():
    .enter_into_state()
    speed = rand_range(MOVE_SPEED, RUN_SPEED)

func _get_dest():
    var tile_map = node.get_node("/root").find_node("TileMap", true, false)

    var cells = tile_map.get_used_cells()
    var max_cell_x = 0
    for cell in cells:
        var cell_pos = tile_map.map_to_world(cell)
        max_cell_x = max(max_cell_x, cell_pos.x)

    var dest = Vector2(max_cell_x, node.global_position.y + rand_range(-20, 20))
    return path_finder.get_closest_point(dest)