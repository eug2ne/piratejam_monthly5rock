extends Control
class_name CharacterIndicator

var parent: Character
@onready var anim: AnimationPlayer = $AnimationPlayer

var label: PackedScene = preload("res://character/character indicator/label/IndicatorLabel.tscn")
@onready var states_container: BoxContainer = $GridContainer/States

# labels
@onready var critical_label: IndicatorLabel = $DamageContainer/Critical
@onready var damage_label: IndicatorLabel = $DamageContainer/Damage
@onready var parry_label: IndicatorLabel = $DamageContainer/Parry
@onready var debuff_label: IndicatorLabel = $GridContainer/States/Debuff

signal _end_alert

func _ready():
	parent = get_parent()

func _process(delta):
	global_position = parent.global_position

func _start_alert():
	anim.play("alert")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "alert":
		# emit end_alert signal
		emit_signal("_end_alert")

func _start_lockon():
	anim.play("lockon")
	
func _show_critical():
	# show critical
	critical_label._show()
	
func _show_damage(damage: float):
	# show damage label
	damage_label._show(str(damage).pad_decimals(1))
	
func _show_parry():
	parry_label._show()

func _show_debuff():
	debuff_label._show()

func _add_state(state_name: String, state_show_time: float):
	# add state label to states container
	var new_label: IndicatorLabel = label.instantiate()
	new_label.label_timeout.connect(_delete_state)
	# pass state_time to new_label
	new_label.show_time = state_show_time
	# show new_label
	states_container.add_child(new_label)
	new_label._show(state_name)

func _delete_state(state_label: IndicatorLabel):
	print("delete label")
	# delete label
	states_container.remove_child(state_label)
