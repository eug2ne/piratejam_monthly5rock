# credits
	# NYKNCK - Pixel Art Effect - FX084 https://nyknck.itch.io/fx084
	# AxulArt - Small 8-direction Characters https://axulart.itch.io/small-8-direction-characters
	# 0x72 - 16x16 DungeonTileset II - https://0x72.itch.io/dungeontileset-ii
	# Poppy Works - Silver font https://poppyworks.itch.io/silver

extends Node2D

@export var current_pc_index: int = 0
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

@onready var combat_UI: Control = $CanvasLayer/CombatUI
@onready var main_camera: MainCamera = $MainCamera


func _input(event) -> void:
	if event.is_action_pressed("switch_pc"):
		# switch current_pc
		if current_pc_index == pc_group.size() - 1:
			current_pc_index = 0
		else:
			current_pc_index += 1
		
		current_pc = pc_group[current_pc_index]
		
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)

func _ready() -> void:
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	current_pc = pc_group[current_pc_index]
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)
