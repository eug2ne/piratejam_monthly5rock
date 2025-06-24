extends State


func _on_enter() -> void:
	# stop character
	parent.velocity = Vector2.ZERO
	super()

func _on_animation_player_animation_finished(anim_name):
	# remove character from scene after animation
	# death animation is not interrupted by other animation
	if anim_name == "death" && get_parent()._get_current_state() == self:
		# FIXME: do not queue_free if parent is PC
		parent.queue_free()
		
		# remove character from enemy target when dead
		var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
		for enemy: Character in enemies:
			enemy._remove_target(parent)
