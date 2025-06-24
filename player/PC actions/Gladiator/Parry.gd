extends Action

func _process(_delta) -> void:
	if parent.velocity == Vector2(0,0):
		return
		
	# place target_area according to parent position + direction
	target_area.global_position = parent.global_position + parent.velocity.normalized() * 24
	# flip target_area according to parent direction
	if parent.velocity.normalized().x > 0:
		target_area.get_node("AnimatedSprite2D").flip_h = true
	if parent.velocity.normalized().x < 0:
		target_area.get_node("AnimatedSprite2D").flip_h = false

func _on_target_area_area_entered(area: Area2D) -> void:
	# FIXME: make character not take damage when parry successful
	# get target
	if area.get_parent() is EnemyAction:
		var enemy_attack: EnemyAction = area.get_parent()
		var enemy: Character = enemy_attack.parent
		
		var parent_accuracy: float = parent.character_resource.accuracy
		var parent_bonus_ap: float = parent.character_resource.bonus_ap
		var target_agility = enemy.character_resource.agility
		var target_defense = enemy.character_resource.defense
		
		# parry enemy attack
		var critical: bool = parent.character_resource._check_critical()
		enemy_attack._parry(action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical), critical, parent)
		# bounce off enemies
		var enemy_direction: Vector2 = parent.global_position.direction_to(enemy.global_position)
		enemy.global_position += enemy_direction.normalized() * 25
		# apply stun to enemy
		enemy.state_manager._set_current_state("stun", action_resource.stun_duration, action_resource.stun_damage)
		
		# signal indicator
		indicator._show_parry()
