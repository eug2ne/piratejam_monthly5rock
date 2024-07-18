extends Node
class_name Action

@export var parent: CharacterBody2D

var targets: Array[CharacterBody2D] # enemy / pc affected by action
@onready var target_area: Area2D = $Area2D
var target_pos: Vector2 # position of the action area
@export var target_group: String # character groups affected by action

var action_available: bool = true
@export var cool_time: float
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer

func _start_action() -> void:
	# TODO: place target_area according to parent position + direction
	# play action animation
	anim.play("action")
	# set cool-time
	action_available = false
	timer.start(cool_time)

func _on_timer_timeout() -> void:
	# reset action_available
	action_available = true

func _on_target_area_body_entered(body) -> void:
	# TODO: get targets
	# TODO: apply action to target in targets
	pass
