extends State
class_name EnemyState

# physics property
var SPEED = 30

const IDLE_SPEED = 30
const MOVE_SPEED = 50

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
