extends CharacterBody2D
class_name Projectile

@export var target_group: String = "enemy"
var target: CharacterBody2D
@export var SPEED: float = 70
@export var LIFE: float = 3
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var life_timer: Timer = $LifeTimer
# throw values
var throw: bool = false
var dir: Vector2


func sort_by_distance(target1,target2) -> bool:
	var target1_distance = global_position.distance_to(target1.global_position)
	var target2_distance = global_position.distance_to(target2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if target1_distance == target2_distance:
		# if distance is equal, sort by process_priority
		return target1.process_priority < target2.process_priority
	else:
		return target1_distance < target2_distance

func _ready() -> void:
	# set interact of interaction_area
	interaction_area.interact = _throw
	# disable collision
	collision_shape.disabled = true

# BUG: how to pass t_group from character?
func _throw(t_group: String = "") -> void:
	# enable collision
	collision_shape.disabled = false
	
	if t_group:
		target_group = t_group
	
	# get closest target
	var targets: Array[Node] = get_tree().get_nodes_in_group(target_group)
	targets.sort_custom(sort_by_distance)
	target = targets[0]
	print(target)
	
	dir = global_position.direction_to(target.global_position)
	print(dir)
	# TODO: throw self to target
	throw = true
	anim.play("throw")
	# start life_timer
	life_timer.start(LIFE)

func _hit() -> void:
	# TODO: need to detect hit
	# play hit animation
	anim.play("hit")
	# destruct self
	queue_free()

func _physics_process(_delta):
	if throw:
		velocity = dir * SPEED
		move_and_slide()

func _on_life_timer_timeout():
	# destruct self
	queue_free()
