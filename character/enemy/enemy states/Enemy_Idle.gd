extends EnemyState

var move_direction: Vector2
var idle_time: float

func randomize_idle() -> void:
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	idle_time = randf_range(1,2)

func _ready():
	SPEED = IDLE_SPEED
	randomize_idle()

func _update_process(delta):
	if idle_time > 0:
		idle_time -= delta
	else:
		randomize_idle()
		
func _update_physics(_delta):
	parent.velocity = move_direction * SPEED
