extends State

@export var movement_controller: MovementController

# states
@export var dash_state: State
@export var dead_state: State

func _on_enter() -> void:
	# do not play animation
	# enable input on action_manager
	action_manager.input_disabled = false
	# set movement_controller speed to default speed
	movement_controller.SPEED = movement_controller.DEFAULT_SPEED
	
func _update_input(event) -> void:
	# handle dash event
	if event.is_action_pressed("dash"):
		# next state to dash_state
		next_state = dash_state
		# change state to dash
		emit_signal("Transition")
		return
		
	# handle basic movement
	movement_controller._handle_input(event)
	
func _update_process(delta):
	movement_controller._handle_process(delta)
	
func _update_physics(delta):
	movement_controller._handle_physics(delta)
