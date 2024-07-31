extends Node
class_name State

@export var anim_key: String
@export var revive: bool
# reference to parent
var parent: CharacterBody2D
var anim: AnimationPlayer
var action_manager: ActionManager
var indicator: CharacterIndicator

var next_state: State
signal Transition

func _on_enter() -> void:
	# play state animation
	anim.play(anim_key)
	
func _on_exit() -> void:
	# define next_state
	pass
	
func _update_process(_delta) -> void:
	pass
	
func _update_physics(_delta) -> void:
	pass
	
func _update_input(_event) -> void:
	pass
