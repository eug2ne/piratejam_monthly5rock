extends State

@export var effects_anim: AnimationPlayer

func _on_enter() -> void:
	# play animaiton from effects_anim
	effects_anim.play(anim_key)
