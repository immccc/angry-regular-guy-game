extends Object

var id
var node
var action_receiver_node setget _set_action_receiver_node

func _init(id, node):
    self.id = id
    self.node = node

func _set_action_receiver_node(node):
    action_receiver_node = weakref(node)

func process(delta):
    pass

func get_next_state():
    return id

func enter_into_state():
	pass