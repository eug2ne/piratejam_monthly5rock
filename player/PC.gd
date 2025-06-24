extends Character
class_name PlayableCharacter

@export var current: bool = false

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var movement_controller: MovementController = $MovementController
@onready var effects_sprite: AnimatedSprite2D = $EffectsAnimatedSprite2D

func _ready() -> void:
	super()
	effects_sprite.visible = false

func _get_actions() -> Dictionary:
	return action_manager.actions
	
func _set_current(new_current: bool) -> void:
	# set current, input_disabled
	current = new_current
	action_manager.input_disabled = !current
	
	if current:
		# set pc state to default
		state_manager._set_current_state("default")
	else:
		# set pc state to idle
		state_manager._set_current_state("idle")
