extends Node
class_name Action

@export var parent: Character

var targets: Array[Character] # enemy / pc affected by action
@onready var target_area: Area2D = $Area2D
var target_pos: Vector2 # position of the action area
@export var target_group: String # character groups affected by action

var action_available: bool = true
@export var cool_time: float
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true

func _start_action() -> void:
	# play action animation
	anim.play("action")
	# set cool-time
	action_available = false
	timer.start(cool_time)
	
func _stop_action() -> void:
	# stop action animation
	anim.stop()
	# disable target_area
	target_area.visible = false
	target_area.get_node("CollisionShape2D").disabled = true
	timer.start(cool_time)

func _on_timer_timeout() -> void:
	# reset action_available
	action_available = true

func _on_target_area_body_entered(_body) -> void:
	pass
