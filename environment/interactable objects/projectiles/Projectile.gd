extends AnimatableBody2D
class_name Projectile

@export var target_group: String = "enemy"
var target: CharacterBody2D
@export var SPEED: float = 70
@export var LIFE: float = 3
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var anim: AnimationPlayer = $AnimationPlayer
var dir: Vector2


func sort_by_distance(target1,target2) -> bool:
	var target1_distance = global_position.distance_to(target1.global_position)
	var target2_distance = global_position.distance_to(target2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if target1_distance == target2_distance:
		# if distance is equal, sort by priority
		return target1.priority < target2.priority
	else:
		return target1_distance < target2_distance

func _ready() -> void:
	# set interact of interaction_area
	interaction_area.interact = _throw

func _throw(t_group: String = "") -> void:
	if t_group:
		target_group = t_group
	
	# get closest target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance)
	target = targets[0]
	
	dir = global_position.direction_to(target.global_position)
	# TODO: throw self to target
	anim.play("throw")

func _hit() -> void:
	# play hit animation
	anim.play("hit")
	# TODO: destruct self
