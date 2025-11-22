extends AudioStreamPlayer


func _randomize_pitch() -> void:
	# randomize pitch of audio
	pitch_scale = randf_range(1.2, 1.4)
