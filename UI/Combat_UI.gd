extends Control

var current_pc_index: int = 0
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

# UI elements
@onready var pc_profile_containers: Array[Node] = $PCBoxContainer.get_children()
@onready var pc_action_containers: Array[Node] = $HBoxContainer.get_children()

func _set_current_pc(new_pc_index: int, new_pc: PlayableCharacter) -> void:
	# adjust old current pc_mcontainer
	pc_profile_containers[current_pc_index].set_scale(Vector2(1,1))
	
	current_pc_index = new_pc_index
	current_pc = new_pc
	
	# enlarge current pc_mcontainer
	pc_profile_containers[current_pc_index].set_scale(Vector2(1.2,1.2))
	
	# show current_pc actions
	var current_pc_actions: Dictionary = current_pc._get_actions()
	pc_action_containers[0]._set_action(current_pc_actions.values()[1]) # secondary action
	pc_action_containers[1]._set_action(current_pc_actions.values()[0]) # basic action
	pc_action_containers[2]._set_action(current_pc_actions.values()[2]) # special action
	
func _process(_delta) -> void:
	# show pc hp
	for i: int in range(pc_group.size()):
		var health_string: String = str(pc_group[i].character_resource.hp) + "/" + str(pc_group[i].character_resource.max_hp)
		pc_profile_containers[i].get_node("HealthLabel").text = health_string
