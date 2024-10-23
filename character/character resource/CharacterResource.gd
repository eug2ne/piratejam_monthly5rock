extends Resource
class_name CharacterResource

@export var character_name: String
var max_hp: float
@export var hp: float

@export var idle_speed: float = 30
@export var move_speed: float = 200
@export var dash_speed: float = 300

@export var defense: float # max 30
@export var agility: float # max 30
@export var accuracy: float # max 20
@export var critical_rate: float # max 40

# bonus points
var bonus_ap: float = 0
var bonus_critical_rate: float = 0

# bonus states
var deflect: bool = false # deflect damage to enemies when taken damage

# UI resource
@export var ui_profile: Texture

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _check_miss(target_agility: float) -> bool:
	# check miss
	if rng.randi_range(0,30) < target_agility:
		return true
	return false

func _check_critical() -> bool:
	# check critical
	if rng.randi_range(0,40) < critical_rate + bonus_critical_rate:
		return true
	return false
	
func _apply_damage(damage: float) -> void:
	if damage <= 0 || hp == 0:
		return
	
	# take damage from enemy
	hp -= damage
	
	if hp <= 0:
		hp = 0 # reset hp to 0
		
func _apply_heal(heal: float) -> void:
	# recover damage
	hp += heal
	
	if hp > max_hp:
		hp = max_hp
