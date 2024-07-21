extends Character


func _physics_process(_delta) -> void:
	move_and_slide()
	
func _take_damage(damage: float, from: Character) -> void:
	super(damage, from)
	
	if character_resource.hp != 0:
		# change state to attack + set target
		state_manager._set_current_state("attack")
