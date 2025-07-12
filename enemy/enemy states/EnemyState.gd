extends State
class_name EnemyState

# physics property
var SPEED: float

# assigned value by state_manager
var IDLE_SPEED: float
var MOVE_SPEED: float
var DASH_SPEED: float

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
