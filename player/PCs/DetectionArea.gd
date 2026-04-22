extends InteractionArea

@export var parent: Character

func _ready() -> void:
	_set_action_available(false)

func _on_body_entered(body: CharacterBody2D) -> void:
	if !action_available:
		return
	if body is PlayableCharacter && body.current && body.character_resource.character_name == "healer":
		# only register when visible + healer entered
		InteractionManager._register_area(self)

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is PlayableCharacter && body.current && body.character_resource.character_name == "healer":
		InteractionManager._unregister_area(self)

func _revive() -> void:
	# TODO: revive parent
	return
