# credits
	# NYKNCK - Pixel Art Effect - FX084 https://nyknck.itch.io/fx084
	# NYKNCK - Pixel Art Effect - FX010 https://nyknck.itch.io/pixel-art-effectfx010
	# NYKNCK - Pixel Explosion - https://nyknck.itch.io/explosion
	# NYKNCK - Effect - https://nyknck.itch.io/effectnpt
	# NYKNCK - Effect - https://nyknck.itch.io/effectlt
	# NYKNCK - Free FX - Pixel Art Effect - FX062 - https://nyknck.itch.io/fx062
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
		# set current for each pc
		for pc: Node in pc_group:
			if pc == current_pc:
				pc._set_current(true)
			else:
				pc._set_current(false)
		
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)

func _ready() -> void:
	# set current for each pc
	current_pc = pc_group[current_pc_index]
	for pc: Node in pc_group:
		if pc == current_pc:
			pc._set_current(true)
		else:
			pc._set_current(false)
	# pass current_pc_index + current_pc to CombatUI + MainCamera
	combat_UI._set_current_pc(current_pc_index, current_pc)
	main_camera._set_current_pc(current_pc_index, current_pc)
	
func _process(_delta):
	# TODO: spawn enemies every 10 sec
	pass
