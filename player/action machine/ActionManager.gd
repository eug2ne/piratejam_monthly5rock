extends Node
class_name ActionManager

@export var parent: CharacterBody2D

# actions
@export var basic_action: Action
@export var secondary_action: Action
@export var special_action: Action

func _input(event):
	# deal input
	if event.is_action_pressed("basic_action") && basic_action.action_available:
		basic_action._start_action()
	
	if event.is_action_pressed("secondary_action") && secondary_action.action_available:
		secondary_action._start_action()
		
	if event.is_action_pressed("special_action") && special_action.action_available:
		special_action._start_action()
