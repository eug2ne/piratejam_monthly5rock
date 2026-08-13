extends Action

# throw configs
var target: Character
var initial_position: Vector2
var activated: bool = false
var hit: bool = false
# physics values
var SPEED: float
var THROW_TIME: float = 2 # default: 2 seconds
var TIMESTAMP: float = 0.0
# damage
var DEFAULT_BASE_DAMAGE: float = 30

@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D
@onready var raycast: RayCast2D = $AnimatableBody2D/RayCast2D


func _ready():
	# assign + disable target_area
	target_area = $AnimatableBody2D/Area2D
	target_area.get_child(0).disabled = true
	# disable raycast
	raycast.enabled = false

func sort_by_distance(target1, target2):
	var target1_distance = animatable_body.global_position.distance_to(target1.global_position)
	var target2_distance = animatable_body.global_position.distance_to(target2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if target1_distance == target2_distance:
		# if distance is equal, sort by priority
		return target1.priority < target2.priority
	else:
		return target1_distance < target2_distance

func _get_target() -> Character:
	# get target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance)
	var target: Character = null
	if targets.size() > 0:
		target = targets[0]
	
	return target

func get_bottle_speed(bottle_pos: Vector2, target_pos: Vector2, DELTA: float) -> float:
	var distance: float = bottle_pos.distance_to(target_pos)
	return distance / DELTA

func get_intercept(initial_pos: Vector2, bottle_speed: float, target_position: Vector2, target_velocity: Vector2) -> Vector2:
	# parabola trajectory calculation
	var a: float = bottle_speed*bottle_speed - target_velocity.dot(target_velocity)
	var b: float = 2*target_velocity.dot(target_pos - initial_pos)
	var c: float = (target_position - initial_position).dot(target_position - initial_pos)
	
	if bottle_speed > target_velocity.length():
		THROW_TIME = (b+sqrt(b*b + 4*a*c)) / (2*a)
	
	return target_pos + THROW_TIME*target_velocity

func _throw():
	# reset TIMESTAMP
	TIMESTAMP = 0.0
	# get target + direction + angle
	target = _get_target()
	initial_position = animatable_body.global_position
	
	if parent.character_resource.character_name.to_lower() == "gladiator" && initial_position.distance_to(target.global_position) < 50:
		# increase base_damage
		# TODO: add special animation for bottle swing
		action_resource.base_damage = DEFAULT_BASE_DAMAGE * 1.5
	elif parent.character_resource.character_name.to_lower() == "healer" && initial_position.distance_to(target.global_position) > 180:
		# increase base_damage
		# TODO: add special animation for bottle launch
		action_resource.base_damage = DEFAULT_BASE_DAMAGE * 1.5
	else:
		action_resource.base_damage = DEFAULT_BASE_DAMAGE
	
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

func _on_target_area_body_entered(body: Node2D) -> void:
	# get target
	if body is Character && body.is_in_group(target_group):
		hit = true
		# stop timer
		timer.stop()
		
		# play action animation
		if (anim.current_animation != "action"):
			action_audio.pitch_scale = randf_range(0.8, 1.4)
			anim.play("action")
		
		var parent_accuracy: float = parent.character_resource.accuracy
		var parent_power: float = parent.character_resource.power
		var target_agility = body.character_resource.agility
		var target_defense = body.character_resource.defense
		var critical: bool = body == raycast.get_collider() # critical damage when bottle directly hits the target
		
		if !critical:
			critical = parent.character_resource._check_critical()
		
		# apply damage to target
		var damage: float = action_resource._deal_damage(target_agility, target_defense, parent_accuracy, parent_power, critical)
		if damage < 0:
			damage = 0
		body._take_damage(damage, critical, parent)

func _on_anim_started(anim_name: String) -> void:
	if (anim_name == "action"):
		Engine.time_scale = freeze_time_scale

func _on_anim_finished(anim_name: String) -> void:
	if (anim_name == "action"):
		Engine.time_scale = 1.0
		# destroy self
		queue_free()

func _physics_process(delta: float) -> void:
	if !activated:
		return
	
	# FIXME: move toward target in parabola trajectory
	TIMESTAMP += delta
	
	if !target:
		# get new target
		target = _get_target()
	SPEED = get_bottle_speed(animatable_body.global_position, target.global_position, THROW_TIME-TIMESTAMP)
	var vector = (target.global_position - animatable_body.global_position).normalized()
	if hit:
		# slow down velocity
		if animatable_body.global_position.distance_to(target.global_position) < 16:
			animatable_body.global_position += Vector2.ZERO
		elif (SPEED > 0):
			animatable_body.global_position += vector * SPEED * 0.5 * delta
		else:
			animatable_body.global_position += vector * 100 * delta
	else:
		animatable_body.global_position += vector * SPEED * delta
	
	# set raycast direction
	raycast.target_position = vector * 20
