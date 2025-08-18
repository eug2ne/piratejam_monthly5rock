extends Action

@onready var boost_timer: Timer = $BoostTimer
var boost_time: float = 5


func _process(_delta) -> void:
	# place target_area according to parent position + direction
	target_area.global_position = parent.global_position

func _start() -> void:
	super()
	# add bonus ap, critical rate
	parent.character_resource.bonus_ap = 10
	parent.character_resource.bonus_critical_rate = 5
	# start boost-timer
	boost_timer.start(boost_time)

func _on_boost_timer_timeout():
	# stop animation
	anim.stop()
	target_area.visible = false
	# reset bonus ap, critical rate
	parent.character_resource.bonus_ap = 0
	parent.character_resource.bonus_critical_rate = 0
