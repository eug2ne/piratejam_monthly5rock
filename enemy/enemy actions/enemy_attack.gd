extends EnemyAction

func _on_target_area_body_entered(body) -> void:
	# get target
	if body is Character && body.is_in_group(target_group):
		target = body
		
func _on_animation_finished(_anim_name: String) -> void:
	# deal damage on target
	_deal_damage()
	super(_anim_name)
	
func _deal_damage() -> void:
	# FIXME: enemy attack target when target didn't enter target area
	if !target:
		return
	
	# apply damage to targeta
	var parent_accuracy: float = parent.character_resource.accuracy
	var parent_bonus_ap: float = parent.character_resource.bonus_ap
	var target_agility = target.character_resource.agility
	var target_defense = target.character_resource.defense
	
	var miss: bool = parent.character_resource._check_miss(target_agility)
	if miss:
		target._take_damage(0, false, parent)
	
	var critical: bool = parent.character_resource._check_critical()
	var damage: float = action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical)
	target._take_damage(damage, critical, parent)
