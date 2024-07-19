extends ActionManager


func _process(_delta) -> void:
	if basic_action.action_available:
		basic_action._start_action()
