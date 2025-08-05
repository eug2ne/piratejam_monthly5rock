extends CharacterAction


func _process(_delta) -> void:
	if parent.velocity == Vector2(0,0):
		return
		
	# place target_area according to parent position + direction
	target_area.global_position = parent.global_position + parent.velocity.normalized() * 24
	# flip target_area according to parent direction
	if parent.velocity.normalized().x > 0:
		target_area.get_node("AnimatedSprite2D").flip_h = false
	if parent.velocity.normalized().x < 0:
		target_area.get_node("AnimatedSprite2D").flip_h = true

func _on_target_area_body_entered(body) -> void:
	super(body)
	# bounce off enemies
	if body is Character && body.is_in_group(target_group):
		var enemy_direction: Vector2 = parent.global_position.direction_to(body.global_position)
		body.global_position += enemy_direction.normalized() * 50
