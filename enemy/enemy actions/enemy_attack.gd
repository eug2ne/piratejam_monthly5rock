extends EnemyAction

func _on_target_area_body_entered(body) -> void:
	# get target
	if body is Character && body.is_in_group(target_group):
		# apply damage to target
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		
		var miss: bool = parent.character_resource._check_miss(target_agility)
		if miss:
			body._take_damage(0, false, parent)
		
		var critical: bool = parent.character_resource._check_critical()
		var damage: float = parent.character_resource._deal_damage(target_defense, critical)
		body._take_damage(damage, critical, parent)
