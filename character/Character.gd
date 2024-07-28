extends CharacterBody2D
class_name Character

@export var character_resource: CharacterResource

@onready var indicator: CharacterIndicator = $Indicator
@onready var action_manager: ActionManager = $ActionManager
@onready var state_manager: StateManager = $StateManager
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# set max_hp
	character_resource.max_hp = character_resource.hp

func _take_damage(damage: float, critical: bool, _from: Character) -> void:
	# TODO: add screenshake when character take/deal damage
	# show critical
	if critical:
		indicator._show_critical()
	# pass damage to indicator
	indicator._show_damage(damage)
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
	state_manager._set_current_state("dead")
	
