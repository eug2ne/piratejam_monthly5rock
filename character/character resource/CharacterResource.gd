extends Resource
class_name CharacterResource

@export var character_name: String
var max_hp: int
@export var hp: int

@export var idle_speed: float = 30
@export var move_speed: float = 200
@export var dash_speed: float = 300

# base stats
@export var speed: float # max 20 (action cool time)
@export var movement: float # max 20 (movement speed)
## attack/action
@export var accuracy: float # max 20 (attack hit + bottle throw control)
@export var power: float # max 20 (attack damage rate)
@export var critical: float # max 40 (critical action rate)
## defense
@export var agility: float # max 20 (damage hit/miss control)
@export var defense: float # max 30 (damage control)

# UI resource
@export var ui_profile: Texture

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _check_miss(target_accuracy: float) -> bool:
	# check miss
	if rng.randf_range(1,100) < 65 + defense - target_accuracy:
		return false
	return true

func _check_critical() -> bool:
	# check critical
	if rng.randf_range(0,100) < critical:
		return true
	return false

func _apply_damage(damage: int) -> void:
	if damage <= 0 || hp == 0:
		return
	
	# take damage from enemy (apply defense)
	hp -= damage
	
	if hp <= 0:
		hp = 0 # reset hp to 0

func _apply_heal(heal: int) -> void:
	# recover damage
	hp += heal
	
	if hp > max_hp:
		hp = max_hp
