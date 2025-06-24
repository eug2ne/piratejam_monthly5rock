extends Label
class_name IndicatorLabel

@export var show_time: float = 0.5

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

signal label_timeout

func _ready():
	visible = false

func _show(text_string: String = ""):
	# show label
	visible = true
	if text_string:
		text = text_string
	# start timer
	timer.start(show_time)

func _on_timer_timeout():
	# hide label
	visible = false
	# emit timeout signal
	emit_signal("label_timeout", self)
