extends Action

# throw physics configs
var SPEED: float
@export var REACH: float = 30
const GRAVITY: float = 1
@onready var DRAG: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
var TIMESTAMP: float = 0.0
var target: Character
var initial_position: Vector2
var throw_direction: Vector2
var throw_angle: float
var z_axis: float = 0.0
var activated: bool = false

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var raycast: RayCast2D = $CharacterBody2D/RayCast2D


func _ready():
	# assign target_area
	target_area = $CharacterBody2D/Area2D
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

func get_target() -> Character:
	# get target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance_to_player)
	var target: Character = targets[0]
	
	return target

func get_trajectory(initial_pos: Vector2, direction: Vector2, desired_distance: float, desired_angle: float) -> void:
	# TODO: need to adjust trajectory (more curve toward target)
	initial_position = initial_pos
	throw_direction = direction.normalized()
	throw_angle = desired_angle + 30
	
	SPEED = pow(abs(desired_distance * GRAVITY / sin(2 * deg_to_rad(desired_angle))), 0.5)
	
	character_body.global_position = initial_position
	TIMESTAMP = 0.0

func _throw():
	# activate bottle
	activated = true
	
	# get target + direction + angle
	target = get_target()
	var direction: Vector2 = character_body.global_position.direction_to(target.global_position).normalized()
	var distance: float = character_body.global_position.distance_to(target.global_position)
	var angle: float = direction.angle()
	get_trajectory(character_body.global_position, direction, distance, angle)
	
	# enable raycast
	raycast.enabled = true

func _physics_process(delta: float) -> void:
	if !activated:
		return
	
	# TODO: move toward target in parabola trajectory
	TIMESTAMP += delta
	
	z_axis = SPEED * sin(deg_to_rad(throw_angle)) * TIMESTAMP - 0.5 * GRAVITY
	if abs(z_axis) > 0:
		var x_axis: float = SPEED * cos(deg_to_rad(throw_angle)) * TIMESTAMP
		character_body.global_position = initial_position + throw_direction * x_axis
		# set raycast direction
		raycast.target_position = character_body.velocity.normalized() * REACH
	
	# detect hit from target using raycast
	#if raycast.is_colliding():
		#print("raycast colliding")
		#if character_body.global_position.distance_to(target.global_position) < 30:
			#print("hit!!!!")
			#character_body.velocity = Vector2(0,0)
			#activated = false
			## TODO: break bottle (hit targets within target_area)
			## FIXME: target_area pushes bottle away
			##target_area.global_position = character_body.global_position
	#else:
		#print("adjust bottle direction")
		## TODO: adjust direction to closest new target
	
	character_body.move_and_slide()
