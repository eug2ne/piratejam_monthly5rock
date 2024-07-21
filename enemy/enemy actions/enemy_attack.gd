extends Action


func _ready():
	target_area.global_position = parent.global_position + Vector2(0,1) * 20

func _on_target_area_body_entered(body) -> void:
	# get target
	if body is Character && body.is_in_group(target_group):
		# apply damage to target
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		body.character_resource._take_damage(parent.character_resource._deal_damage(target_agility, target_defense))

func _parry(parry_damage: float, from: Character):
	# apply parry effect on enemy
	# disable attack
	_stop()
	# apply parry damage to parent
	parent._take_damage(parry_damage, from)


func _on_animation_finished(anim_name: String) -> void:
	# disable attack
	_stop()
