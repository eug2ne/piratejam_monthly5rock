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

func _call_parry():
	print("enemy call parry")
	# TODO: apply parry effect on enemy
	pass
