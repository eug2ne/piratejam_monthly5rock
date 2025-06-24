extends Node
class_name State

@export var anim_key: String
@export var revive: bool
@export var permanant: bool = false
# buff / debuff effect
@export var duration: float
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
	
func _update_process(delta: float) -> void:
	if (!permanant):
		# count down duration
		if duration > 0:
			duration -= delta
		else:
			# end state
			emit_signal("Transition")
	
func _update_physics(_delta) -> void:
	pass
	
func _update_input(_event) -> void:
	pass
