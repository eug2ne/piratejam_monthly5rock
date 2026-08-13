extends EnemyState
# TODO: create PC idle state

@export var movement_controller: MovementController

var detected_enemy: Character
var move_direction: Vector2
var idle_time: float

func randomize_idle() -> void:
	if detected_enemy:
		# set move_direction to dodge enemy
		var enemy_direction: Vector2 = parent.global_position.direction_to(detected_enemy.global_position)
		move_direction = ((Vector2(randf_range(-1,1), randf_range(-1,1)) - enemy_direction) / 2).normalized()
		idle_time = randf_range(1,2)
	else:
		move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
		idle_time = randf_range(1,2)

func _on_enter():
	movement_controller.SPEED = movement_controller.IDLE_SPEED
	randomize_idle()

func _update_process(delta):
	if idle_time > 0:
		idle_time -= delta
	else:
		randomize_idle()
	
	movement_controller._handle_process(delta)
		
func _update_physics(delta) -> void:
	parent.velocity = move_direction * movement_controller.SPEED
	parent.move_and_slide()

func _on_detection_area_body_entered(body) -> void:
	if body.is_in_group("enemy"):
		detected_enemy = body

func _on_detection_area_body_exited(body) -> void:
	if body.is_in_group("enemy"):
		detected_enemy = null
