extends EffectArea

func _apply_effect(target: Character) -> void:
	# TODO: slow entire game time + play sound effect + zoom in to action
	var parent_accuracy: float = parent.character_resource.accuracy
	var parent_bonus_ap: float = parent.character_resource.bonus_ap
	var target_agility = target.character_resource.agility
	var target_defense = target.character_resource.defense
	
	# check miss
	var miss: bool = parent.character_resource._check_miss(target_agility)
	if miss:
		# debuff miss
		return
	
	# apply damage to target
	var critical: bool = parent.character_resource._check_critical()
	var damage: float = parent.action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical)
	target._take_damage(damage, critical, parent)
