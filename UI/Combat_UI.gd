extends Control

var current_pc_index: int = 0
var current_pc: PlayableCharacter

# UI elements
@onready var pc_mcontainers: Array[Node] = $PCBoxContainer.get_children()

func _ready() -> void:
	# TODO: display pc profile
	pass
	
func _set_current_pc(new_pc_index: int, new_pc: PlayableCharacter) -> void:
	current_pc_index = new_pc_index
	current_pc = new_pc
	
	# enlarge current pc_mcontainer
	pc_mcontainers[current_pc_index].set_size(Vector2(110,110))
	# TODO: adjust pc_mcontainer opacity
	# TODO: change key / stat profile
