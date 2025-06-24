extends Character

@export var target_group: String

func _physics_process(_delta) -> void:
	move_and_slide()
	
func _take_damage(damage: float, critical: bool, from: Character = null) -> void:
	super(damage, critical, from)
	
	if character_resource.hp != 0:
		if (state_manager._get_current_state().name.to_lower() == "stun"):
			# ignore attack
			return
		else:
			# change state to attack + set target
			state_manager._set_current_state("attack")
			state_manager.current_state.target = from

func _remove_target(character: Character) -> void:
	if state_manager.current_state.name.to_lower() == "attack":
		if state_manager.current_state.target.character_resrouce.name == character.character_resource.name:
			# remove target
			state_manager.current_state.target = null
			# change state to idle
			state_manager._set_current_state("idle")

func _on_area_2d_body_entered(body):
	if (state_manager._get_current_state().name.to_lower() == "stun"):
		# ignore pc
		return
	
	if body is Character && body.is_in_group(target_group):
		# change state to attack
		state_manager._set_current_state("attack")
		# assign target to attack state
		if state_manager.current_state.name.to_lower() != "dead":
			state_manager.current_state.target = body
