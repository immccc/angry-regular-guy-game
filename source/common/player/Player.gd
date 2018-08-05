extends Node2D

const KICK_STRENGTH = 1

onready var player_control = preload("player_control.gd").new(get_node("."))
onready var sprite = $Sprite


var objects_to_kick = Array()
var objects_to_punch = Array()

func _physics_process(delta):
	player_control.process_input(delta)
	_process_hits()


func get_width():
	sprite.get_frame(sprite.animation, sprite.frame).get_width()

func _process_hits():
	if player_control.is_kicking_climax():
		for object_to_kick in objects_to_kick:
			object_to_kick.emit_signal("hit_received", KICK_STRENGTH, _get_person_direction())

func _on_kick_area_area_entered(area):
	objects_to_kick.append(area)

func _on_kick_area_area_exited(area):
	objects_to_kick.erase(area)

func _get_person_direction():
	if sprite.flip_h == true:
		return -1
	else:
		return 1