extends Node
class_name ActionManager

@export var parent: CharacterBody2D
@export var input_disabled: bool # if true, do not deal input

# actions
@export var basic_action: Action
@export var secondary_action: Action
@export var special_action: Action
# track current action
var current_action: Action

func _input(event):
	if input_disabled:
		return
	
	# deal input
	if event.is_action_pressed("basic_action") && basic_action.action_available:
		basic_action._start()
	
	if event.is_action_pressed("secondary_action") && secondary_action.action_available:
		secondary_action._start()
		
	if event.is_action_pressed("special_action") && special_action.action_available:
		special_action._start()
		
func _stop_current_action():
	# stop current_action
	if current_action:
		current_action._stop()
	
func _on_current_action_end(action: Action):
	if current_action == action:
		# remove action from current_action
		current_action = null
