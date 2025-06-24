extends State
class_name EnemyState

# physics property
var SPEED: float

@onready var IDLE_SPEED: float = parent.character_resource.idle_speed
@onready var MOVE_SPEED: float = parent.character_resource.move_speed
@onready var DASH_SPEED: float = parent.character_resource.dash_speed

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
