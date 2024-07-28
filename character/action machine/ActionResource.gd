extends Resource
class_name ActionResource

@export var action_name: String
@export var base_damage: float
@export var parry_action: bool

# UI resource
@export var ui_texture: Texture

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _deal_damage(target_defense: float, parent_accuracy: float, critical: bool) -> float:
	# get parry damage
	if parry_action:
		if critical:
			# critical parry deal
			return snappedf(base_damage * rng.randf_range(1.5,2), 0.1)
		else:
			return roundf(base_damage * rng.randf_range(1,1.2))
	
	# get damage according to base_damage + accuracy + critical_rate + target_agility + target_defense
	if critical:
		# critical deal >> do not apply target_agility + target_defense
		return snappedf(base_damage * rng.randf_range(1,2), 0.1)
		
	if rng.randi_range(0,100) > parent_accuracy:
		# miss deal
		## pass miss to indicator?
		return roundf(base_damage * rng.randf_range(0,parent_accuracy) / 20)
	
	else:
		# hit deal >> apply target_defense
		return roundf(base_damage - rng.randf_range(0,target_defense))
