extends Action

@export var SPEED: float = 70
@export var REACH: float = 17.5
@onready var character_body: CharacterBody2D = $Area2D/CharacterBody2D
@onready var raycast: RayCast2D = $Area2D/CharacterBody2D/RayCast2D


func _ready():
	# disable raycast
	raycast.enabled = false

func sort_by_distance_to_player(target1, target2):
	var target1_distance = PlayerManager.current_pc.global_position.distance_to(target1.global_position)
	var target2_distance = PlayerManager.current_pc.global_position.distance_to(target2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if target1_distance == target2_distance:
		# if distance is equal, sort by priority
		return target1.priority < target2.priority
	else:
		return target1_distance < target2_distance

func _throw():
	# get target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance_to_player)
	var target: Character = targets[0]
	
	# move toward target
	var direction: Vector2 = target_area.global_position.direction_to(target.global_position).normalized()
	character_body.velocity = direction * SPEED
	# enable raycast + set raycast direction
	raycast.target_position = direction * REACH
	raycast.enabled = true
	
	print(parent)
	print("throw")

func _physics_process(_delta: float) -> void:
	# TODO: move toward target in parabola trajectory
	character_body.move_and_slide()
	
	# detect hit from target using raycast
	if raycast.is_colliding():
		character_body.velocity = character_body.velocity / 2
		raycast.enabled = false
		# TODO: break bottle (hit targets within target_area)
