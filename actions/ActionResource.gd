extends Resource
class_name ActionResource

@export var action_name: String
@export var base_damage: float
@export var parry: bool
@export var area: bool

# UI resource
@export var ui_texture: Texture

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _deal_damage(target_agility: float, target_defense: float, parent_accuracy: float, parent_power: float, critical: bool) -> int:
	# get total_damage
	var total_damage: float = base_damage * (1 + parent_power / 20)
	
	# get parry damage
	if parry:
		if critical:
			# critical parry deal
			return roundi(total_damage * rng.randf_range(1.5, 2))
		else:
			return roundi(total_damage * rng.randf_range(1, 1.2))
	
	# get damage according to base_damage + accuracy + target_defense
	if critical:
		# critical deal >> do not apply target_defense
		return roundi(total_damage * rng.randf_range(1, 2))
	
	return roundi(total_damage * (1 - rng.randf_range((target_defense-5) / 30, (target_defense+5) / 30)))

func _deal_heal(parent_accuracy: float, parent_power: float, critical: bool) -> int:
	# get total_heal
	var total_heal: float = base_damage * (1 + parent_power / 20)
	
	# get damage according to total_heal + accuracy + critical
	if critical:
		# critical heal
		return roundi(total_heal * rng.randf_range(1, 2))
	
	if rng.randi_range(0,20) > parent_accuracy:
		# miss
		# TODO: pass miss to indicator
		return roundi(total_heal * rng.randf_range(0.8, 1.2))
	else:
		return roundi(total_heal)
