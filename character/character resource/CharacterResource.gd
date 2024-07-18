extends Resource
class_name CharacterResource

@export var character_name: String
@export var hp: float
@export var ap: float
@export var accuracy: float
@export var cirtical_rate: float

func _deal_damage() -> float:
	# return damage to enemy
	return 0
	
func _take_damage(damage: float) -> void:
	# take damage from enemy
	hp -= damage
	
func _deal_death() -> void:
	# deal death
	pass
