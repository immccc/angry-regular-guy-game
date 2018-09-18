extends Node2D

class LineFunc:
    var m
    var b
    func _init(m, b):
        self.m = m
        self.b = b

    func get_y(x):
        return m * x + b

class Line:
    var start
    var end

    func _init(start, end):
        self.start = start
        self.end = end

    func get_func():
        var delta_x = end.x - start.x
        var delta_y = end.y - start.y
        var m
        if delta_x == 0:
            m = INF * sign(delta_y)
        else:
            m = delta_y / delta_x

        var b = start.y - (start.x * m)
        return LineFunc.new(m, b)


#TODO extends to any other kind of character
const Person = preload("res://scenes/characters/person/regular_pedestrian.tscn")

export(bool) var debug_mode = false
export(int) var initial_people_on_queue_amount = 3
export(int) var capacity = 3

var positions = []

onready var area = $Area
onready var shape = $Area/Shape

func _ready():
    _update_positions()
    _fill_with_initial_people()

func _process(delta):
    #area.rotation_degrees += 5 * delta
    _update_positions()
    update()

func _draw():
    if !debug_mode:
        return

    _draw_queue_line()
    _draw_positions()

func _draw_queue_line():
    var queue_line = _get_queue_line()

    var color = Color(1.0, 0.0, 0.0, 1.0)
    draw_line(queue_line.start, queue_line.end, color, 3)

func _draw_positions():
    var color = Color(1.0, 0.5, 0.5, 1.0)
    for position in positions:
        draw_circle(position, 5, color)

func _get_order_in_queue(object_position):
    var intersecting_point = _get_intersecting_point_in_queue(object_position)
    var queue_line = _get_queue_line()

    return intersecting_point.distance_to(queue_line.start) * 100 / queue_line.end.distance_to(queue_line.start)

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

func _update_positions():
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
    #TODO Person creation must be handled by world container
    var created_persons = 0
    for position in positions:
        var person = Person.instance()
        add_child(person)
        person.global_position = to_global(position)
        created_persons += 1
        if created_persons == initial_people_on_queue_amount:
            return




