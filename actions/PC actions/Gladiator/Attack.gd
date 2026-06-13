extends Action

@onready var hit_audio: AudioStreamPlayer = $HitAudio


func _on_target_area_body_entered(body) -> void:
	if body is Character && body.is_in_group(target_group):
		# play hit_audio
		hit_audio.pitch_scale = randf_range(0.8, 1.4)
		hit_audio.play()
	
	super(body)

func _process(_delta) -> void:
	if parent.velocity == Vector2(0,0):
		return
		
	# place target_area according to parent position + direction
	target_area.global_position = parent.global_position + parent.velocity.normalized() * 24
	# flip target_area according to parent direction
	if parent.velocity.normalized().x > 0:
		target_area.get_node("AnimatedSprite2D").flip_h = true
	if parent.velocity.normalized().x < 0:
		target_area.get_node("AnimatedSprite2D").flip_h = false
