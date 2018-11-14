var m
var b

func _init(m, b):
    self.m = m
    self.b = b

func get_y(x):
    return m * x + b