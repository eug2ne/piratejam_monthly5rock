extends State


func _on_enter() -> void:
	# stop character
	parent.velocity = Vector2(0,0)
	super()

func _on_animation_player_animation_finished(anim_name):
	# remove character from scene after animation
	# death animation is not interrupted by other animation
	# FIXME: remove character from enemy target when dead
	if anim_name == "death" && get_parent()._get_current_state() == self:
		parent.queue_free()
