extends Node
class_name MovementController

@export var parent: Character
@export var anim: AnimationPlayer
@onready var timer: Timer = $Timer

var direction: Vector2
var SPEED: float
@onready var DEFAULT_SPEED: float = parent.character_resource.move_speed
@onready var DASH_SPEED: float = parent.character_resource.dash_speed

func _ready():
	# set speed to default_speed
	SPEED = DEFAULT_SPEED
	# set shader parameter
	parent.material.set_shader_parameter("flash_modifier", 0)

func _input(event) -> void:
	# handle input event
	var directionX = Input.get_axis("move_left", "move_right")
	var directionY = Input.get_axis("move_up", "move_down")
	direction = Vector2(directionX, directionY)
	
	# handle dash event
	if event.is_action_pressed("dash"):
		# apply dash speed
		SPEED = DASH_SPEED
		# start dash timer
		timer.start(0.5)

func _physics_process(_delta) -> void:
	parent.velocity = direction * SPEED
	parent.move_and_slide()
	
func _process(_delta) -> void:
	# handle parent animation according to parent.velocity
	if SPEED == DASH_SPEED:
		# play dash animation
		anim.play("dash")
		return
	
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

func _on_timer_timeout():
	# reset speed to default_speed
	SPEED = DEFAULT_SPEED
