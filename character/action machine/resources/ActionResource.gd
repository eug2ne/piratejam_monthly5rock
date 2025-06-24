extends Resource
class_name ActionResource

@export var action_name: String
@export var base_damage: float
# effect info
@export var parry: bool
@export var stun: bool = false
@export var stun_duration: float = 0
@export var stun_damage: int = 0
@export var effect: bool
@export var effect_duration: int = 0
@export var effect_damage: int = 0

# UI resource
@export var ui_texture: Texture

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _deal_damage(target_defense: float, parent_accuracy: float, parent_bonus_ap: float, critical: bool) -> float:
	# get total_damage
	var total_damage: float = base_damage + parent_bonus_ap
	
	# get parry damage
	if parry:
		if critical:
			# critical parry deal
			return snappedf(total_damage * rng.randf_range(1.5,2), 0.1)
		else:
			return roundf(total_damage * rng.randf_range(1,1.2))
	
	# get damage according to base_damage + accuracy + critical_rate + target_agility + target_defense
	if critical:
		# critical deal >> do not apply target_agility + target_defense
		return snappedf(total_damage * rng.randf_range(1,2), 0.1)
		
	if rng.randi_range(0,100) > parent_accuracy:
		# miss deal
		## pass miss to indicator?
		return roundf(total_damage * rng.randf_range(0,parent_accuracy) / 20)
	
	else:
		# hit deal >> apply target_defense
		return roundf(total_damage - rng.randf_range(0,target_defense))
		
func _deal_heal_debuff(parent_accuracy: float, parent_bonus_ap: float, critical: bool) -> float:
	# get total_effect
	var total_effect: float = base_damage + parent_bonus_ap
	
	# get damage according to total_heal + accuracy + critical
	if critical:
		# critical heal
		return snappedf(total_effect * rng.randf_range(1,2), 0.1)
		
	if rng.randi_range(0,100) > parent_accuracy:
		# miss deal
		## pass miss to indicator?
		return roundf(total_effect * rng.randf_range(0,parent_accuracy) / 20)
	
	else:
		# hit deal
		return roundf(total_effect)
