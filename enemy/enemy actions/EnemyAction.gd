extends Action
class_name EnemyAction

var target: Character
@export var distance: float

# Timers
@onready var lockon_timer: Timer = $Timers/LockOnTimer
@onready var cooltime_timer: Timer = $Timers/CoolTimeTimer

signal action_end(action: Action)

func _lock_on(direction: Vector2i) -> void:
	print(parent)
	# set target_area position
	target_area.global_position = parent.global_position + direction * distance
	# play character lockon animations
	indicator._start_lockon()
	# start lockon timer
	lockon_timer.start(0.5)

func _start() -> void:
	# play action animation
	anim.play("action")
	# set cool-time
	action_available = false
	cooltime_timer.start(cool_time)

func _parry(parry_damage: float, critical:bool, from: Character):
	print("parry")
	# disable enemy attack
	_stop()
	# apply parry damage to parent
	parent._take_damage(parry_damage, critical, from)
	# reset cool-time
	cooltime_timer.start(cool_time)
	
func _on_animation_finished(anim_name: String) -> void:
	# disable attack
	_stop()
	emit_signal("action_end", self)
	
func _on_lock_on_timer_timeout():
	# attack target
	_start()
	
func _on_cool_time_timer_timeout():
	# disable attack
	_stop()
	emit_signal("action_end", self)
	# reset action_available
	action_available = true
