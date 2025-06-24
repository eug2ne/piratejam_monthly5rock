extends State


func _on_enter() -> void:
	# find all enemies
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	# disengage with all enemies
	for e in enemies:
		e._remove_target(self)
	
	# stop parent
	parent.movement_controller.direction = Vector2(0,0)
	parent.movement_controller.SPEED = 0
	
	# disable parent collision body
	parent.collision.disabled = true
	
	# TODO: set parent image to hide behind object
	# apply shader to parent
	parent.material.set_shader_parameter("flash_color", "3a3a3a")
	parent.material.set_shader_parameter("flash_modifier", 0.5)

func _on_exit() -> void:
	# restore parent speed
	parent.movement_controller.SPEED = parent.character_resource.move_speed
	
	# enable parent collidion body
	parent.collision.disabled = false
