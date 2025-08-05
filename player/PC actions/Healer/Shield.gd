extends CharacterAction
# TODO: create eggshell (egg protection to all pcs for 10 sec)

@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

func _start() -> void:
	# heal + create eggshell to all pcs
	for pc: Node in pc_group:
		pc._take_heal(action_resource.base_damage, false, parent)
		pc.state_manager._set_current_state("shield")
	
	# start cool-time timer
	timer.start(cool_time)
	
func _stop() -> void:
	super()
