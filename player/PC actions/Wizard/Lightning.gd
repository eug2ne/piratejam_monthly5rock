extends CharacterAction


func _process(_delta) -> void:
	if parent.velocity == Vector2(0,0):
		return
		
	# place target_area according to parent position + direction
	target_area.global_position = parent.global_position + parent.velocity.normalized() * 50
	# flip target_area according to parent direction
	if parent.velocity.normalized().x > 0:
		target_area.get_node("AnimatedSprite2D").flip_h = false
	if parent.velocity.normalized().x < 0:
		target_area.get_node("AnimatedSprite2D").flip_h = true
