extends Node2D

const DirectionType = preload("res://source/common/direction.gd").Direction
const RegularPedestrian = preload("res://scenes/characters/person/regular_pedestrian.tscn")

const Line = preload("line.gd")
const PersonInQueueProperties = preload("person_in_queue_properties.gd")

signal initial_people_requested_to_be_added(object_node_type, object_position, direction, node_caller, prepare_object_to_be_added_method)

export(bool) var debug_mode = false
export(int) var initial_people_on_queue_amount = 3
export(int) var capacity = 3
export(int) var amount_people_bothered_behind_intrusion = 0

onready var debug_info_font = (Label.new()).get_font("font")

var positions = []
var rank_per_position_ranges = {}
var properties_per_person = {}
var people = []

onready var area = $Area
onready var shape = $Area/Shape

func _ready():
    _fill_positions()
    _fill_with_initial_people()
    _fill_rank_per_position_ranges()

func _process(delta):
    _update_people_ranking()
    _notify_people_to_be_bothered()

    if debug_mode:
        update()

func add_person(person):
    people.append(person)
    var properties = PersonInQueueProperties.new()
    properties.joined_time = OS.get_unix_time()
    properties_per_person[person] = properties

func remove_person(person):
    people.erase(person)
    properties_per_person.erase(person)

func _update_people_ranking():
    for person in people:
        var properties = properties_per_person[person]
        properties.rank = _get_rank(person)

func _notify_people_to_be_bothered():
    for potentially_bothering_person in people:
        var bothered_people = _get_bothered_people(potentially_bothering_person)
        #TODO REMOVE, ONLY DEBUG!!!!!!!!!
        if bothered_people.size() > 0:
            print("BOTHERING %s IS BOTHERING %s" % [potentially_bothering_person, bothered_people])

func _get_bothered_people(potentially_bothering_person):
    var bothered_people = []
    var potentially_bothering_person_rank = properties_per_person[potentially_bothering_person].rank
    var potentially_bothering_person_joined_time = properties_per_person[potentially_bothering_person].joined_time

    for potentially_bothered_person in properties_per_person:
        var potentially_bothered_person_rank = properties_per_person[potentially_bothered_person].rank
        var potentially_bothered_person_joined_time = properties_per_person[potentially_bothered_person].joined_time
        var potentially_bothering_person_is_in_front = potentially_bothered_person_rank <= potentially_bothered_person_rank && potentially_bothered_person_rank >= potentially_bothering_person_rank - amount_people_bothered_behind_intrusion
        var potentially_bothering_person_joined_later = potentially_bothering_person_joined_time > potentially_bothered_person_joined_time

        if potentially_bothering_person_is_in_front and potentially_bothering_person_joined_later:
            bothered_people.append(potentially_bothered_person)

    return bothered_people

func _get_rank(person):
    var pos = to_local(person.global_position)
    var order = _get_order_in_queue(pos)

    for ranking_order_range in rank_per_position_ranges:
        if order >= ranking_order_range[0] and order <= ranking_order_range[1]:
            return rank_per_position_ranges[ranking_order_range]

    return people.size()

func _get_order_in_queue(object_position):
    var intersecting_point = _get_intersecting_point_in_queue(object_position)
    var queue_line = _get_queue_line()

    return round(intersecting_point.distance_to(queue_line.start) * 100 / queue_line.end.distance_to(queue_line.start))

func _get_queue_line():
    var half_line_height = Vector2(- (shape.shape.height/2 + shape.shape.radius) * sin(area.rotation), (shape.shape.height/2 + shape.shape.radius) * cos(area.rotation))
    return Line.new(area.position - half_line_height, area.position + half_line_height)

func _get_line_intersecting_queue_from_position(pos):

    var queue_line = _get_queue_line()
    var line_vector = queue_line.end - queue_line.start
    var line_vector_normalized = line_vector.normalized()
    line_vector_normalized = Vector2(- line_vector_normalized.y, line_vector_normalized.x)
    return Line.new(pos, pos + line_vector_normalized * (shape.shape.radius * 2))

func _get_intersecting_point_in_queue(pos):
    var queue_line_func = _get_queue_line().get_func()
    var intersecting_line_func = _get_line_intersecting_queue_from_position(pos).get_func()

    var x
    var y
    if abs(queue_line_func.m) == INF:
        x = _get_queue_line().start.x
    elif intersecting_line_func.m == INF:
        x = _get_line_intersecting_queue_from_position(pos).start.x
    else:
        x = (intersecting_line_func.b - queue_line_func.b) / (queue_line_func.m - intersecting_line_func.m)

    if abs(queue_line_func.m) == INF:
        y = pos.y
    else:
        y = queue_line_func.m * x + queue_line_func.b

    return Vector2(x, y)

func _fill_positions():
    var queue_line = _get_queue_line()

    positions = []

    var queue_line_func = queue_line.get_func()

    if queue_line_func.m == INF:
        for position in range(capacity):
            var x = queue_line.start.x
            var y = queue_line.start.y + (position + 1) * (queue_line.end.y - queue_line.start.y)  / capacity
            positions.append(Vector2(x, y))
    else:
        for position in range(capacity):
            var x = queue_line.start.x + (position + 1) * (queue_line.end.x - queue_line.start.x)  / capacity
            var y = queue_line_func.get_y(x)
            positions.append(Vector2(x, y))

func _fill_with_initial_people():
    var created_regular_pedestrians = 0
    for position in positions:
        if created_regular_pedestrians == initial_people_on_queue_amount:
            return

        emit_signal("initial_people_requested_to_be_added", RegularPedestrian, to_global(position), _get_created_regular_pedestrian_direction(), self, "_setup_regular_pedestrian_state")
        created_regular_pedestrians += 1

func _fill_rank_per_position_ranges():
    var lower_bound = 0
    var ranking = 1
    for position in positions:
        var upper_bound = _get_order_in_queue(position)
        rank_per_position_ranges[[lower_bound, upper_bound]] = ranking
        lower_bound = upper_bound
        ranking += 1

func _get_created_regular_pedestrian_direction():
    return [DirectionType.LEFT, DirectionType.RIGHT][randi() % 2]

func _setup_regular_pedestrian_state(regular_pedestrian):
    regular_pedestrian.initial_state = "wait_in_queue_state"
    add_person(regular_pedestrian)

func _on_queue_area_entered(ground_area_from_object):
    ground_area_from_object.emit_signal("entered_in_queue", self)

func _on_queue_area_exited(ground_area_from_object):
    ground_area_from_object.emit_signal("exited_from_queue", self)


#---
func _draw():
    if !debug_mode:
        return

    _draw_queue_line()
    _draw_positions()
    _draw_ranks()

func _draw_queue_line():
    var queue_line = _get_queue_line()

    var color = Color(1.0, 0.0, 0.0, 1.0)
    draw_line(queue_line.start, queue_line.end, color, 3)

func _draw_positions():
    var color = Color(1.0, 0.5, 0.5, 1.0)
    for position in positions:
        draw_circle(position, 5, color)

func _draw_ranks():
    for person in properties_per_person:
        var rank = properties_per_person[person].rank
        draw_string(debug_info_font, to_local(person.global_position) + Vector2(50, 15), "POSITION %s" % rank, Color(0, 0, 1))