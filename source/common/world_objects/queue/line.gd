const LineFunc = preload("line_func.gd")

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
