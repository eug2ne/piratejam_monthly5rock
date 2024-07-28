extends Node
class_name MovementController

@export var parent: PlayableCharacter
@export var anim: AnimationPlayer

var direction: Vector2
var SPEED: float
@onready var DEFAULT_SPEED: float = parent.character_resource.move_speed
@onready var DASH_SPEED: float = parent.character_resource.dash_speed

func _ready():
	# set speed to default_speed
	SPEED = DEFAULT_SPEED

func _handle_input(event) -> void:
	if !parent.current:
		return
	
	# handle input event
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	direction = Vector2(directionX, directionY).normalized()

func _handle_physics(_delta) -> void:
	parent.velocity = direction * SPEED
	parent.move_and_slide()
	
func _handle_process(_delta) -> void:
	# FIXME: when player take damage, damage animation interrupted by movement animation
		## need to play both animations at the same time
	# handle parent animation according to parent.velocity	
	if parent.velocity.x == 0 && parent.velocity.y > 0:
		# move down
		anim.play("move_down")
	elif  parent.velocity.x == 0 && parent.velocity.y < 0:
		# move up
		anim.play("move_up")
	elif  parent.velocity.x > 0 && parent.velocity.y == 0:
		# move right
		anim.play("move_right")
	elif  parent.velocity.x < 0 && parent.velocity.y == 0:
		# move left
		anim.play("move_left")
	elif  parent.velocity.x > 0 && parent.velocity.y > 0:
		# move down-right
		anim.play("move_downright")
	elif  parent.velocity.x < 0 && parent.velocity.y > 0:
		# move down-left
		anim.play("move_downleft")
	elif  parent.velocity.x > 0 && parent.velocity.y < 0:
		# move up-right
		anim.play("move_upright")
	elif  parent.velocity.x < 0 && parent.velocity.y < 0:
		# move up-left
		anim.play("move_upleft")
