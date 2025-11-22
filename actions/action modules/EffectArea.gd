extends Area2D
class_name EffectArea

@export var parent: Action

func _apply_effect(target: Character) -> void:
	pass

func _on_body_entered(body) -> void:
	# get target + apply effect
	if body is Character && body.is_in_group(parent.target_group):
		_apply_effect(body)
