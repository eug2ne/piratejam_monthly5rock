extends CharacterBody2D
class_name Character

@export var character_resource: CharacterResource

@onready var anim: AnimationPlayer = $AnimationPlayer

func _take_damage(damage: float) -> void:
	# apply damage to character hp
	character_resource._apply_damage(damage)
	# play damage animation
	anim.play("damage")
	
	if character_resource.hp == 0:
		# character death
		_take_death()
	
func _take_death() -> void:
	# stop character
	velocity = Vector2(0,0)
	# play death animation
	anim.play("death")
	# TODO: disable character / remove characer from scene after death animation
	pass
	
