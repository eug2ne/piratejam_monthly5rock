extends AnimatableBody2D
class_name Projectile

@export var SPEED: float = 70

@onready var collision_area: Area2D = $Area2D
@onready var anim: AnimationPlayer = $AnimationPlayer


func sort_by_distance(t1, t2):
	var t1_distance = global_position.distance_to(t1.global_position)
	var t2_distance = global_position.distance_to(t2.global_position)
	
	if t1_distance == t2_distance:
		# if distance is equal, sort by priority
		return t1.priority < t2.priority
	else:
		return t1_distance < t2_distance

func _throw(target_group: String) -> void:
	# search nearest target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance)
	var nearest_target: Node = targets.front()
	
	# get direction to target
	var direction: Vector2 = global_position.direction_to(nearest_target.global_position)
	direction.normalized()
	# throw self to target
	move_and_collide(direction * SPEED)
	# play throw animation
	anim.play("throw")

func _hit(body: Character) -> void:
	# play hit animation
	anim.play("hit")
	# TODO: get affected enemies >> apply effect + damage
	# destroy self
	free()
