extends Effect


func _add(char: Character) -> void:
	super(char)
	# set target state to idle
	target.state_manager._set_current_state("idle", duration)

func _process(delta) -> void:
	# apply stun effect on target
	if target && !timer.is_stopped():
		if target is PlayableCharacter:
			target.movement_controller.IDLE_SPEED = 0
			target.movement_controller.SPEED = 0
		else:
			target.state_manager.current_state.IDLE_SPEED = 0
			target.state_manager.current_state.MOVE_SPEED = 0

func _end() -> void:
	# restore default movement speed
	if target is PlayableCharacter:
		target.movement_controller.IDLE_SPEED = target.character_resource.idle_speed
		target.movement_controller.SPEED = target.character_resource.move_speed
	else:
		target.state_manager.current_state.IDLE_SPEED = target.character_resource.idle_speed
		target.state_manager.current_state.MOVE_SPEED = target.character_resource.move_speed
