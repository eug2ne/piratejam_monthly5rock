extends Node2D

@export var current_pc_index: int = 0
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

@onready var combat_UI: Control = get_node("/root/main/CanvasLayer/CombatUI")
@onready var main_camera: MainCamera = get_node("/root/main/MainCamera")

func _input(event) -> void:
	if event.is_action_pressed("switch_pc"):
		# switch current_pc
		if current_pc_index == pc_group.size() - 1:
			current_pc_index = 0
		else:
			current_pc_index += 1
		
		current_pc = pc_group[current_pc_index]
		# set current for each pc
		for pc: Node in pc_group:
			if pc == current_pc:
				pc._set_current(true)
			else:
				pc._set_current(false)
		
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)

func _load() -> void:
	# set current for each pc
	current_pc = pc_group[current_pc_index]
	for pc: Node in pc_group:
		if pc == current_pc:
			pc._set_current(true)
		else:
			pc._set_current(false)
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	if !combat_UI || !main_camera:
		combat_UI = get_node("/root/Main/CanvasLayer/CombatUI")
		main_camera = get_node("/root/Main/MainCamera")
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)
