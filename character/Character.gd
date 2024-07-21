extends CharacterBody2D
class_name Character

@export var character_resource: CharacterResource

@onready var action_manager: ActionManager = $ActionManager
@onready var state_manager: StateManager = $StateManager
@onready var anim: AnimationPlayer = $AnimationPlayer

func _take_damage(damage: float, _from: Character) -> void:
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
	action_manager._stop_current_action()
	# TODO: disable character / remove characer from scene after death animation
	state_manager._set_current_state("dead")
	
