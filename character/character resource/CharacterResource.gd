extends Resource
class_name CharacterResource

@export var character_name: String
@export var hp: float
@export var ap: float # base deal
@export var parry_damage: float # parry deal (max 20)

@export var move_speed: float
@export var dash_speed: float

@export var defense: float # max 30
@export var agility: float # max 30
@export var accuracy: float # max 20
@export var critical_rate: float # max 40

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _check_miss(target_agility: float) -> bool:
	# check miss
	if rng.randi_range(0,30) < target_agility:
		return true
	return false

func _check_critical() -> bool:
	# check critical
	if rng.randi_range(0,40) < critical_rate:
		return true
	return false

func _deal_damage(target_defense: float, critical: bool) -> float:
	# get damage according to ap + accuracy + critical_rate + target_agility + target_defense
	if critical:
		# critical deal >> do not apply target_agility + target_defense
		# TODO: pass critical to indicator
		return snappedf(ap * rng.randf_range(1,2), 0.1)
		
	if rng.randi_range(0,100) > accuracy:
		# miss deal
		## pass miss to indicator?
		return roundf(ap * rng.randf_range(0,accuracy) / 20)
	
	else:
		# hit deal >> apply target_defense
		return roundf(ap - rng.randf_range(0,target_defense))
		
func _deal_parry_damage(critical: bool) -> float:
	if critical:
		# critical deal
		return snappedf(parry_damage * rng.randf_range(1.5,2), 0.1)
	else:
		return roundf(parry_damage * rng.randf_range(1,1.2))
	
func _apply_damage(damage: float) -> void:
	if damage <= 0 || hp == 0:
		return
	
	# take damage from enemy
	hp -= damage
	
	if hp <= 0:
		hp = 0 # reset hp to 0
