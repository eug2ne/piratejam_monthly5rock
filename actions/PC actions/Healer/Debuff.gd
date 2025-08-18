extends Action

@export var debuff_stat: String


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
	# recover pc health
	# get target
	if body is Character && body.is_in_group(target_group):
		# use ap as effect factor
		var parent_accuracy: float = parent.character_resource.accuracy
		var parent_bonus_ap: float = parent.character_resource.bonus_ap
		var target_agility = body.character_resource.agility
		
		# check miss
		var miss: bool = parent.character_resource._check_miss(target_agility)
		if miss:
			# debuff miss
			return
		
		# apply debuff to target
		var critical: bool = parent.character_resource._check_critical()
		var debuff: float = action_resource._deal_heal_debuff(parent_accuracy, parent_bonus_ap, critical)
		body._take_debuff(debuff, debuff_stat)
