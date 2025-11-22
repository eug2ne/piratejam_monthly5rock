extends Action

# trajectory physics values
var SPEED: float
var THROW_TIME: float = 2 # default: 2 seconds
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
var hit: bool = false

@onready var character_body: CharacterBody2D = $CharacterBody2D
@onready var raycast: RayCast2D = $CharacterBody2D/RayCast2D


func _ready():
	# assign + disable target_area
	target_area = $CharacterBody2D/Area2D
	target_area.get_child(0).disabled = true
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

func get_bottle_speed(bottle_pos: Vector2, target_pos: Vector2, DELTA: float) -> float:
	var distance: float = bottle_pos.distance_to(target_pos)
	return distance / DELTA

func get_intercept(initial_pos: Vector2, bottle_speed: float, taret_position: Vector2, target_velocity: Vector2) -> Vector2:
	var a: float = bottle_speed*bottle_speed - target_velocity.dot(target_velocity)
	var b: float = 2*target_velocity.dot(target_pos - initial_pos)
	var c: float = (target_pos - initial_position).dot(target_pos - initial_pos)
	
	if bottle_speed > target_velocity.length():
		THROW_TIME = (b+sqrt(b*b + 4*a*c)) / (2*a)
	
	return target_pos + THROW_TIME*target_velocity

func get_trajectory(initial_pos: Vector2, target_pos: Vector2) -> void:
	# FIXME: calculate trajectory values differently depending on target_distance
	# set trajectory values
	initial_position = initial_pos
	throw_direction = initial_pos.direction_to(target_pos).normalized()
	throw_angle = abs(rad_to_deg(throw_direction.angle()))
	raycast.target_position = throw_direction * 100
	
	# get height of the trajectory
	DISTANCE = initial_pos.distance_to(target_pos) * 1.5 # muptiply 1.5 for 
	HEIGHT = DEFAULT_HEIGHT * height_damp / DISTANCE * 100
	# TODO: calculate SPEED based on distance + time
	SPEED = DISTANCE / THROW_TIME

func _throw():
	# reset TIMESTAMP
	TIMESTAMP = 0.0
	# get target + direction + angle
	target = get_target()
	initial_position = character_body.global_position
	#get_trajectory(character_body.global_position, target.global_position)
	
	# enable raycast
	raycast.enabled = true
	# enable target_area
	target_area.get_child(0).disabled = false
	
	# activate bottle
	activated = true
	# play throw animation
	anim.play("throw")
	# start timer
	timer.start(THROW_TIME)

func _on_target_area_body_entered(body) -> void:
	if hit:
		return
	
	# get target
	if body is Character && body.is_in_group(target_group):
		hit = true
		# stop timer
		timer.stop()
		
		# play action animation
		anim.play("action")
		Engine.time_scale = freeze_time_scale
		await anim.animation_finished
		print("animation action finished")
		Engine.time_scale = 1.0
		
		var parent_accuracy: float = parent.character_resource.accuracy
		var parent_bonus_ap: float = parent.character_resource.bonus_ap
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		var critical: bool = raycast.is_colliding()
		
		# apply damage to target
		#var damage: float = action_resource._deal_damage(target_defense, parent_accuracy, parent_bonus_ap, critical)
		#body._take_damage(damage, critical, parent)
		# destroy self
		queue_free()

func _physics_process(delta: float) -> void:
	if !activated:
		return
	
	## FIXME: move toward target in parabola trajectory
	TIMESTAMP += delta
	#
	## adjust throw_direction, throw_angle
	#throw_direction = character_body.global_position.direction_to(target.global_position).normalized()
	#throw_angle = abs(rad_to_deg(throw_direction.angle()))
	## adjust SPEED
	#DISTANCE = character_body.global_position.distance_to(target.global_position) * 1.5
	#SPEED = DISTANCE / (THROW_TIME - TIMESTAMP)
	#
	## FIXME: how do i get a parabola trajectory????
	#var x: float
	#var y: float
	#var new_position: Vector2
	## FIXME: update velocity instead of global_position
	#if throw_direction.x < 0:
		#x = -TIMESTAMP * SPEED
		#y = 4*HEIGHT/pow(DISTANCE, 2) * pow((abs(x)-DISTANCE*0.5), 2) - HEIGHT
		#new_position = Vector2(x,y).rotated(deg_to_rad(180-throw_angle))
	#else:
		#x = TIMESTAMP * SPEED
		#y = 4*HEIGHT/pow(DISTANCE, 2) * pow((abs(x)-DISTANCE*0.5), 2) - HEIGHT
		#new_position = Vector2(x,y).rotated(deg_to_rad(-throw_angle))
	#
	#throw_direction = new_position + throw_direction
	#
	#raycast.target_position = throw_direction.normalized() * SPEED
	#
	#character_body.velocity = raycast.target_position
	
	# FIXME: [URGENT] bottle gets bounced off enemy bodies (change to AnimatableBody2D?)
	SPEED = get_bottle_speed(character_body.global_position, target.global_position, THROW_TIME-TIMESTAMP)
	if hit:
		# slow down velocity
		if character_body.global_position.distance_to(target.global_position) < 16:
			character_body.velocity = (target.global_position - character_body.global_position).normalized() * SPEED * 0.1
		else:
			character_body.velocity = (target.global_position - character_body.global_position).normalized() * SPEED * 0.5
	else:
		character_body.velocity = (target.global_position - character_body.global_position).normalized() * SPEED
	
	character_body.move_and_slide()
