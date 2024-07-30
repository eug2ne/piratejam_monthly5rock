extends Action
# TODO: create eggshell (egg protection to all pcs for 10 sec)

@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

func _start() -> void:
	# TODO: create eggshell to all pcs
	for pc: Node in pc_group:
		pc._start_eggshell()
	
	# start cool-time timer
	timer.start(cool_time)
	
func _stop() -> void:
	super()
	# TODO: remove eggshell from all pcs
