extends Node
class_name Action

@export var action_resource: ActionResource
var parent: Character
var indicator: CharacterIndicator

var targets: Array[Character] # enemy / pc affected by action
@onready var target_area: Area2D = $Area2D
var target_pos: Vector2 # position of the action area
@export var target_group: String # character groups affected by action

var action_available: bool = true
@export var freeze_time_scale: float = 0.025 # DEFAULT for basic pc action
@export var freeze_duration: float = 0.5 # DEFAULT for basic pc action
@export var reusable: bool = false
@export var cool_time: float = 0
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $ActionAudio

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
	if reusable:
		# reset action_available
		action_available = true
	else:
		# destroy self
		queue_free()

func _frame_freeze(time_scale: float, duration: float) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1.0

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
		# frame freeze
		if critical:
			_frame_freeze(freeze_time_scale * 1.5, freeze_duration)
		else:
			_frame_freeze(freeze_time_scale, freeze_duration)
		var damage: float = action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical)
		body._take_damage(damage, critical, parent)
