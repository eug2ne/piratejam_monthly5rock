extends Action
class_name EnemyAction

var target: Character
@export var distance: float

var parried: bool = false

# Timers
@onready var lockon_timer: Timer = $Timers/LockOnTimer
@onready var cooltime_timer: Timer = $Timers/CoolTimeTimer

signal action_end(action: Action)

func _lock_on(direction: Vector2i) -> void:
	# set target_area position
	target_area.global_position = parent.global_position + direction * distance
	# play character lockon animations
	indicator._start_lockon()
	# start lockon timer
	lockon_timer.start(0.5)

func _start() -> void:
	# reset target
	target = null
	# play action animation
	anim.play("action")
	# set cool-time
	action_available = false
	cooltime_timer.start(cool_time)

func _parry(parry_damage: float, critical:bool, from: Character):
	# disable enemy attack
	_stop()
	emit_signal("action_end", self)
	# apply parry damage to parent
	parent._take_damage(parry_damage, critical, from)
	
func _on_animation_finished(anim_name: String) -> void:
	# disable attack
	_stop()
	emit_signal("action_end", self)
	
func _on_lock_on_timer_timeout():
	# attack target
	_start()
	
func _on_cool_time_timer_timeout():
	# reset action_available
	action_available = true
