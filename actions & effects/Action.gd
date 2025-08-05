extends Node
class_name Action

@export var action_resource: ActionResource
var parent: Node # parent of action
var character: Character # character doing the action

# target info
var targets: Array[Character] # enemy / pc affected by action
@onready var target_area: Area2D = $Area2D
var target_pos: Vector2 # position of the action area
@export var target_group: String # character groups affected by action


func _ready() -> void:
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true

func _start() -> void:
	# enable target_area
	target_area.visible = true
	target_area.get_node("CollisionShape2D").disabled = false

func _stop() -> void:
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true

func _on_target_area_body_entered(body) -> void:
	# default damage function
	# get target
	if body is Character && body.is_in_group(target_group):
		var character_accuracy: float = character.character_resource.accuracy
		var character_bonus_ap: float = character.character_resource.bonus_ap
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		
		# check miss
		var miss: bool = character.character_resource._check_miss(target_agility)
		if miss:
			# debuff miss
			return
		
		# apply damage to target
		var critical: bool = character.character_resource._check_critical()
		var damage: float = action_resource._deal_damage(target_defense, character_accuracy, character_bonus_ap, critical)
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
