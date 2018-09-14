extends "res://source/common/state/move_state.gd"

const StateConstants = preload("state_constants.gd")
const DirectionType = preload("res://source/common/direction.gd").Direction

const RUN_SPEED_SLOW = 300
const RUN_SPEED_FAST = 400

var tile_map

func _init(id, node).(id, node):
    pass

func get_next_state():
    return id

func enter_into_state():
    tile_map = node.get_node("/root").find_node("TileMap", true, false)
    .enter_into_state()
    speed = rand_range(RUN_SPEED_SLOW, RUN_SPEED_FAST)

func _get_dest():
    if node.global_position.x  - action_receiver_node.get_ref().global_position.x >= 0 :
       return _get_dest_to_right()
    else:
       return _get_dest_to_left()

#TODO Duplicated, do in a common place
func _get_dest_to_left():
   var cells = tile_map.get_used_cells()
   var min_cell_x = INF
   for cell in cells:
       var cell_pos = tile_map.map_to_world(cell)
       min_cell_x = min(min_cell_x, cell_pos.x)

   var dest = Vector2(min_cell_x, node.global_position.y + rand_range(-100, 100))
   return path_finder.get_closest_point(path_finder.to_local(dest))

#TODO Duplicated, do in a common place
func _get_dest_to_right():
    var cells = tile_map.get_used_cells()
    var max_cell_x = -INF
    for cell in cells:
        var cell_pos = tile_map.map_to_world(cell)
        max_cell_x = max(max_cell_x, cell_pos.x)

    var dest = Vector2(max_cell_x, node.global_position.y + rand_range(-100, 100))
    return path_finder.get_closest_point(path_finder.to_local(dest))

