extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var auto_action: bool = false
@export var action_available: bool = true:
	set = _set_action_available,
	get = _get_action_available

var interact: Callable

func _on_body_entered(body: CharacterBody2D) -> void:
	if body != PlayerManager.current_pc:
		return
	if !visible||!action_available:
		return
	# only register when visible
	InteractionManager._register_area(self)

func _on_body_exited(_body: CharacterBody2D) -> void:
	InteractionManager._unregister_area(self)
	
func _set_action_available(new_val: bool) -> void:
	action_available = new_val
	
func _get_action_available() -> bool:
	return action_available
