extends State


func _on_enter() -> void:
	# disable input
	if action_manager:
		action_manager.input_disabled = true
	# stop character
	parent.velocity = Vector2(0,0)
	
	if parent.is_in_group("pc"):
		# TODO: set up revive interaction_area
		pass
	super()

func _on_animation_player_animation_finished(anim_name) -> void:
	# remove character from scene after animation
	# death animation is not interrupted by other animation
	if anim_name == "death" && get_parent()._get_current_state() == self:
		parent.queue_free()
