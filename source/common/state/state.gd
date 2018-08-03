extends Object

var id
var node

func _init(id, node):
    self.id = id
    self.node = node

func process(delta):
    pass

func get_next_state():
    return id

func enter_into_state():
	pass