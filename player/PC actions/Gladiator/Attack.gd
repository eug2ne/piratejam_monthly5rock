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
	
func _on_target_area_body_entered(body) -> void:
	# get target
	if body is Character && body.is_in_group(target_group):
		# apply damage to target
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		body._take_damage(parent.character_resource._deal_damage(target_agility, target_defense), parent)
