extends Action

# trajectory physics values
const SPEED: float = 200
@export var REACH: float = 30
const GRAVITY: float = 1
var DISTANCE: float
var HEIGHT: float
const DEFAULT_HEIGHT: float = 55 # HEIGHT when DISTANCE is 100
@export var height_damp: float = 1
var TIMESTAMP: float = 0.0
var initial_position: Vector2
var throw_direction: Vector2
var throw_angle: float

# throw configs
var target: Character
var z_axis: float = 0.0
var activated: bool = false

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var raycast: RayCast2D = $CharacterBody2D/RayCast2D


func _ready():
	# assign target_area
	target_area = $CharacterBody2D/Area2D
	# disable raycast
	raycast.enabled = false

func sort_by_distance(target1, target2):
	var target1_distance = character_body.global_position.distance_to(target1.global_position)
	var target2_distance = character_body.global_position.distance_to(target2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if target1_distance == target2_distance:
		# if distance is equal, sort by priority
		return target1.priority < target2.priority
	else:
		return target1_distance < target2_distance

func get_target() -> Character:
	# get target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance)
	var target: Character = targets[0]
	
	return target

func get_trajectory(initial_pos: Vector2, target_pos: Vector2) -> void:
	# TODO: calculate SPEED based on distance + time
	# FIXME: calculate trajectory values differently depending on target_distance
	# set trajectory values
	initial_position = initial_pos
	throw_direction = initial_pos.direction_to(target_pos).normalized()
	throw_angle = abs(rad_to_deg(throw_direction.angle()))
	raycast.target_position = throw_direction * 100
	
	# get height of the trajectory
	DISTANCE = initial_pos.distance_to(target_pos)
	HEIGHT = DEFAULT_HEIGHT * height_damp / DISTANCE * 100
	
	TIMESTAMP = 0.0

func _throw():
	# activate bottle
	activated = true
	
	# get target + direction + angle
	target = get_target()
	get_trajectory(character_body.global_position, target.global_position)
	
	# enable raycast
	raycast.enabled = true
	
	# play throw animation
	anim.play("throw")

func _physics_process(delta: float) -> void:
	if !activated:
		return
	
	# move toward target in parabola trajectory
	TIMESTAMP += delta
	
	if TIMESTAMP * SPEED >= DISTANCE:
		activated = false
		return
	
	var x: float
	var y: float
	var new_position: Vector2
	# FIXME: update velocity instead of global_position
	if throw_direction.x < 0:
		x = -TIMESTAMP * SPEED
		y = 4*HEIGHT/pow(DISTANCE, 2) * pow((abs(x)-DISTANCE*0.5), 2) - HEIGHT
		new_position = Vector2(x,y).rotated(deg_to_rad(180-throw_angle))
	else:
		x = TIMESTAMP * SPEED
		y = 4*HEIGHT/pow(DISTANCE, 2) * pow((abs(x)-DISTANCE*0.5), 2) - HEIGHT
		new_position = Vector2(x,y).rotated(deg_to_rad(-throw_angle))
	character_body.global_position = initial_position + new_position
	
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
