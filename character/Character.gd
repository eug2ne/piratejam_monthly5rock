extends CharacterBody2D
class_name Character

@export var character_resource: CharacterResource

@onready var indicator: CharacterIndicator = $Indicator
@onready var action_manager: ActionManager = $ActionManager
@onready var state_manager: StateManager = $StateManager
@onready var effects_anim: AnimationPlayer = $EffectsAnimationPlayer

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
	effects_anim.play("damage")
	
	if character_resource.deflect:
		# TODO: deflect damage to enemy when deflect is true
		pass
	
	if character_resource.hp == 0:
		# character death
		_take_death()
		
func _take_heal(recover: float, critical: bool, _from: Character) -> void:
	# show critical
	if critical:
		indicator._show_critical()
	# pass recover to indicator
	indicator._show_damage(recover)
	# apply recover to character hp
	character_resource._apply_heal(recover)
	# play heal animation
	effects_anim.play("heal")
	
	# revive player
	if state_manager.current_state.name.to_lower() == "dead":
		print("revive")
		state_manager._set_current_state("idle")
	
func _take_debuff(debuff: float, debuff_stat: String) -> void:
	# debuff character stat
	character_resource[debuff_stat] -= debuff
	# pass debuff to indicator
	indicator._show_debuff()
	
func _take_death() -> void:
	# stop character
	velocity = Vector2(0,0)
	state_manager._set_current_state("dead")
	
