extends Node2D

@onready var PCs: Array[Node] = get_tree().get_nodes_in_group("pc")
@onready var label: Label = $Label

const base_text: String = "press [e] to "

var active_areas: Array[InteractionArea] = []
var can_interact: bool = true

func _register_area(area: InteractionArea):
	if area.auto_action && area._get_action_available():
		# directly implement interact function
		can_interact = false # prevent label.show() + input event
		await area.interact.call()
		can_interact = true
		return
		
	active_areas.push_back(area)
	print(active_areas)

func _unregister_area(area: InteractionArea):
	var i = active_areas.find(area)
	if i != -1:
		# set available to true
		active_areas[i]._set_action_available(true)
		# remove from active_areas
		active_areas.remove_at(i)

func sort_by_distance_to_player(area1, area2):
	var area1_distance = PlayerManager.current_player.global_position.distance_to(area1.global_position)
	var area2_distance = PlayerManager.current_player.global_position.distance_to(area2.global_position)
	# use PlayerManager.current_player instead of player to prevent bug
	
	if area1_distance == area2_distance:
		# if distance is equal, sort by priority
		return area1.priority < area2.priority
	else:
		return area1_distance < area2_distance
	
func _input(event):
	if event.is_action_pressed("interact") && label.visible:
		can_interact = false
		label.hide()
		
		await active_areas[0].interact.call()
		
		if (!active_areas.is_empty()):
			_unregister_area(active_areas[0]) # unregister activated area
		can_interact = true

func _process(_delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		
		# show label
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.x -= label.size.x / 2
		label.global_position.y -= 30
		label.show()
	else:
		label.hide()
