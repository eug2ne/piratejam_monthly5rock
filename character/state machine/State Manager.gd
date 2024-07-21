extends Node
class_name StateManager

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

# imported from parent
@export var parent: Character
@export var action_manager: ActionManager

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# assign state variable
			child.parent = parent
			child.anim = parent.get_node("AnimationPlayer")
			child.action_manager = action_manager
		else:
			push_warning("WARNING: " + child.name + " is not State.")
	
	if initial_state:
		# start initial state
		current_state = initial_state
		current_state._on_enter()
		
func _input(event):
	if current_state:
		current_state._update_input(event)
	
func _process(delta):
	if current_state:
		current_state._update_process(delta)

func _physics_process(delta):
	if current_state:
		current_state._update_physics(delta)
	
func _set_current_state(state_key: String = ""):
	# prevent redundancy
	if current_state.name.to_lower() == state_key:
		return
	
	print("state change")
	# exit current_state
	current_state._on_exit()
	
	# get new_state
	var new_state: State
	if state_key:
		new_state = states.get(state_key)
	else:
		new_state = current_state.next_state
	print(current_state.name, " ", new_state.name)
	
	# assign new state
	current_state = new_state
	current_state._on_enter()
	
func _get_current_state():
	return current_state
