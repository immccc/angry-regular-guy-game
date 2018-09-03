extends "res://source/common/state/state.gd"

const ANIMATION_MOVE = "walk"

var sprite
var path_finder
var speed

var path

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	path_finder = node.get_node("/root").find_node("PathFinder", true, false)

func process(delta):
	sprite.play(ANIMATION_MOVE)
	_move(delta)

func enter_into_state():
	var dest = _get_dest()

	path = path_finder.get_simple_path(path_finder.to_local(node.global_position), dest)

	path.remove(0)

func _get_dest():
	pass

func _move(delta):
	if _is_path_finished():
		return

	var current_position = node.global_position
	var next_point_on_path = path_finder.to_global(path[0])

	var step = speed * delta
	var distance_to_next_point_on_path = current_position.distance_to(next_point_on_path)
	if distance_to_next_point_on_path == 0.0:
		distance_to_next_point_on_path = step

	var next_position = current_position.linear_interpolate(next_point_on_path, step / distance_to_next_point_on_path)

	if (current_position - next_position).length() > (next_point_on_path - next_position).length():
		node.global_position = next_point_on_path
		path.remove(0)
	else:
		node.global_position = next_position

func _is_path_finished():
	return path == null or path.size() == 0
