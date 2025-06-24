extends Node
class_name Action

@export var action_resource: ActionResource
var parent: Character
var indicator: CharacterIndicator

# target info
var targets: Array[Character] # enemy / pc affected by action
@onready var target_area: Area2D = $Area2D
var target_pos: Vector2 # position of the action area
@export var target_group: String # character groups affected by action

# action info
var action_available: bool = true
@export var cool_time: float
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer

# effect info

func _ready() -> void:
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true

func _start() -> void:
	# play action animation
	anim.play("action")
	# set cool-time
	action_available = false
	timer.start(cool_time)
	
func _stop() -> void:
	# stop action animation
	anim.stop()
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true

func _on_timer_timeout() -> void:
	# reset action_available
	action_available = true

func _on_target_area_body_entered(body) -> void:
	# default damage function
	# get target
	if body is Character && body.is_in_group(target_group):
		var parent_accuracy: float = parent.character_resource.accuracy
		var parent_bonus_ap: float = parent.character_resource.bonus_ap
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		
		# check miss
		var miss: bool = parent.character_resource._check_miss(target_agility)
		if miss:
			# debuff miss
			return
		
		# apply damage to target
		var critical: bool = parent.character_resource._check_critical()
		var damage: float = action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical)
		body._take_damage(damage, critical, parent)
		
		# apply stun to target
		if (action_resource.stun):
			body.state_manager._set_current_state("stun", action_resource.stun_duration, action_resource.stun_damage)
		
		# apply effect to target
		#if (action_resource.effect):
			#var t_state: TemporaryState = effect.instantiate()
			## assign effect duration, damage
			#t_state.duration = action_resource.effect_duration
			#t_state.damage = action_resource.effect_damage
			#body._take_effect(t_state)
