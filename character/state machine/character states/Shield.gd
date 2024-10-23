extends State

@export var effects_anim: AnimationPlayer
@onready var timer: Timer = $Timer

func _on_enter() -> void:
	# play animaiton from effects_anim
	effects_anim.play(anim_key)

func _on_timer_timeout():
	# change to default state
	emit_signal("Transition")
