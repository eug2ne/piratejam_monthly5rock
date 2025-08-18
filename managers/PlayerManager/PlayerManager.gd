extends Node2D

# current player data
@export var current_pc_index: int = 0
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

func _input(event) -> void:
	if event.is_action_pressed("switch_player"):
		# switch current_pc
		if current_pc_index == pc_group.size() - 1:
			current_pc_index = 0
		else:
			current_pc_index += 1
		
		# disable current_pc
		current_pc.current = false
		# assign new current_pc
		current_pc = pc_group[current_pc_index]
		current_pc.current = true

func _ready() -> void:
	# set current_pc
	current_pc = pc_group[current_pc_index]
	current_pc.current = true
