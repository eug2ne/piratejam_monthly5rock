extends AnimatedSprite2D
class_name Effect

@export var effect_name: String
@export var duration: float
@export var damage: float
@export var crit: float
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
var target: Character

func _add(char: Character) -> void:
	target = char
	# add label to target indicator
	target.indicator.states_container.add_child(self.label)
	
	# TODO: adjust position accordingly to target
	
	# start timer, animation
	timer.start(duration)
	anim.play("effect_anim")

func _process(delta) -> void:
	# apply effect on target
	pass

func _end() -> void:
	# destroy self
	free()
