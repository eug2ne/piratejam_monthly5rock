extends State

@export var effects_anim: AnimationPlayer
@onready var timer: Timer = $Timer

func _on_enter() -> void:
	# disable input on action_manager
	action_manager.input_disabled = true
	# stop character
	parent.velocity = Vector2(0,0)
	# play animaiton from effects_anim
	effects_anim.play(anim_key)

func _on_timer_timeout():
	# change to default state
	emit_signal("Transition")
