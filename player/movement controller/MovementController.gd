extends Node
class_name MovementController

@export var parent: Character
@export var anim: AnimationPlayer

var direction: Vector2
@onready var SPEED: float = parent.character_resource.move_speed

func _input(event):
	# handle input event
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	direction = Vector2(directionX, directionY)
	
	# TODO: handle dash event

func _physics_process(_delta):
	parent.velocity = direction * SPEED
	parent.move_and_slide()

func _process(_delta):
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
