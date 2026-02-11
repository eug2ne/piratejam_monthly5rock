extends Node2D

# current player data
@export var current_pc_index: int = 0
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")
# UI components
@onready var combat_UI: Control = get_node("/root/Main/CanvasLayer/CombatUI")
@onready var main_camera: MainCamera = get_node("/root/Main/MainCamera")

func _input(event) -> void:
	if event.is_action_pressed("switch_pc"):
		# switch current_pc
		if current_pc_index == pc_group.size() - 1:
			current_pc_index = 0
		else:
			current_pc_index += 1
		
		# disable current_pc
		current_pc._set_current(false)
		# assign new current_pc
		current_pc = pc_group[current_pc_index]
		current_pc._set_current(true)
		
		_update_ui_system()

func _ready() -> void:
	# set current_pc
	current_pc = pc_group[current_pc_index]
	current_pc.current = true
	
	# update ui components when current_pc is ready
	current_pc.connect("ready", _update_ui_system)

func _update_ui_system() -> void:
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)
