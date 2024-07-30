extends VBoxContainer
class_name ActionContainer

@export var key: String
var action: Action

@onready var key_label: Label = $KeyLabel
@onready var action_label: Label = $ActionLabel
@onready var timer_label: Label = $TimerLabel


func _ready() -> void:
	# set key_label
	key_label.text = key

func _process(delta):
	# set timer_label
	if round(action.timer.time_left) == 0:
		# hide timer_label
		timer_label.visible = false
	else:
		# show left cool-time
		timer_label.visible = true
		timer_label.text = str(round(action.timer.time_left))

func _set_action(new_action: Action) -> void:
	action = new_action
	# set action_label
	action_label.text = action.action_resource.action_name
