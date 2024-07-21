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
	# get target
	var enemy_attack: Action = area.get_parent()
	# parry enemy attack
	if enemy_attack.has_method("_parry"):
		# pass parry damage
		enemy_attack._parry(parent.character_resource._deal_parry_damage(), parent)