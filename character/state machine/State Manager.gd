extends Node
class_name StateManager

var states: Dictionary = {}
var current_state: State
@export var initial_state: State
@export var default_state: State

# imported from parent
@export var parent: Character
@export var action_manager: ActionManager
@export var indicator: CharacterIndicator

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# assign state variable
			child.parent = parent
			child.anim = parent.get_node("AnimationPlayer")
			child.action_manager = action_manager
			child.indicator = indicator
		else:
			push_warning("WARNING: " + child.name + " is not State or TmeporaryState.")
	
	if initial_state:
		# start initial state
		current_state = initial_state
		current_state._on_enter()
		
func _input(event):
	if parent is PlayableCharacter && !parent.current:
		return
	
	if current_state:
		current_state._update_input(event)

func _process(delta):
	if current_state:
		current_state._update_process(delta)

func _physics_process(delta):
	if current_state:
		current_state._update_physics(delta)

func _set_current_state(state_key: String = "", state_duration: float = 0):
	if current_state:
		# prevent redundancy
		if current_state.name.to_lower() == state_key:
			return
		# not revivable
		if current_state.name.to_lower() == "dead" && !current_state.revive:
			return
		
		# exit current_state
		current_state._on_exit()
	
	# get new_state
	var new_state: State
	if state_key:
		new_state = states.get(state_key)
	else:
		new_state = current_state.next_state
		
	if !new_state:
		# FIXME: when changing state dash >> idle, _set_current_state called twice + new_state not found
		# set new_state to default state
		new_state = default_state
	
	# assign new state
	current_state = new_state
	# assign state_duration
	if (!current_state.permanant):
		current_state.duration = state_duration
	current_state._on_enter()
	
func _get_current_state():
	return current_state

func _on_state_transition():
	_set_current_state()
