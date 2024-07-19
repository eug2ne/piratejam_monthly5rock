extends Resource
class_name CharacterResource

@export var character_name: String
@export var hp: float
@export var ap: float # base deal

@export var move_speed: float

@export var defense: float # max 30
@export var agility: float # max 30
@export var accuracy: float # max 20
@export var critical_rate: float # max 40

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _deal_damage(target_agility: float, target_defense: float) -> float:
	# get damage according to ap + accuracy + critical_rate + target_agility + target_defense
	if rng.randi_range(0,100) > accuracy:
		# miss deal
		return ap * rng.randi_range(0,accuracy) / 20
	
	if rng.randi_range(0,40) < critical_rate:
		# critical deal >> do not apply target_agility + target_defense
		return ap * rng.randf_range(1,2)
		
	if rng.randi_range(0,30) < target_agility:
		# miss deal
		return 0
	else:
		# hit deal >> apply target_defense
		return ap - rng.randi_range(0,defense)
	
func _take_damage(damage: float) -> void:
	if damage <= 0 || hp == 0:
		return
	
	# take damage from enemy
	hp -= damage
	
	if hp <= 0:
		hp = 0 # reset hp to 0
		_take_death() # character death
	
func _take_death() -> void:
	# TODO: add death effect
	pass
