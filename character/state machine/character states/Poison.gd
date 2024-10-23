extends State

# TODO: add aditional damage over time to parent
var damage: int
var critical: int
var from: Character
@export var effects_anim: AnimationPlayer
@onready var timer: Timer = $Timer

func _on_enter() -> void:
	# play animaiton from effects_anim
	effects_anim.play(anim_key)

func _process(delta) -> void:
	parent._take_damage(damage, critical, from)
	pass

func _on_timer_timeout():
	# change to default state
	emit_signal("Transition")
