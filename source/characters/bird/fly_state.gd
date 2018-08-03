extends "res://source/common/state/state.gd"

const ANIMATION_FLY = "flying"

const FLYING_VEL = 200
const FLYING_AMPLITUDE = 0.5
const DIRECTIONS = preload("res://source/common/world_objects/direction.gd")

var Shit = preload("res://scenes/characters/bird/shit/shit.tscn")

var sprite
var direction = DIRECTIONS.Direction.RIGHT
var player
var radians_counter = 0
var shit_thrown = false

func _init(id, node).(id, node):
	sprite = node.get_node("Sprite")
	player = node.get_node("/root").find_node("Player", true, false)

func process(delta):
	sprite.play(ANIMATION_FLY)

	_move(delta)
	_throw_shit_if_applicable()
	
func _move(delta):
	node.global_position.x += FLYING_VEL * direction * delta
	node.global_position.y += FLYING_AMPLITUDE * cos(radians_counter)
	radians_counter += 1.0 * delta

func _throw_shit_if_applicable():
	var x_distance_with_player = abs(node.global_position.x - player.global_position.x)
	var shit_rand_flag = rand_range(0, 100) < 10
	if !shit_thrown and x_distance_with_player  < 100 and shit_rand_flag:
		var thrown_shit = Shit.instance()
		thrown_shit.global_position = node.global_position
		node.get_parent().add_child(thrown_shit)
		shit_thrown = true
	
	

