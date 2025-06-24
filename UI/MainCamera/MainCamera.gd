extends Camera2D
class_name MainCamera

# pc tracker
var current_pc_index: int
var current_pc: PlayableCharacter
@onready var pc_group: Array[Node] = get_tree().get_nodes_in_group("pc")

# camera behaviour
@export var camera_move_speed: float
@export var camera_zoom_speed: float


func _get_incentor_position() -> Vector2:
	# get incentor position of PCs
	var incentor: Vector2
	
	var a: Vector2 = pc_group[0].global_position
	var b: Vector2 = pc_group[1].global_position
	var c: Vector2 = pc_group[2].global_position
	
	var ab: float = sqrt((a-b).x ** 2 + (a-b).y ** 2)
	var bc: float = sqrt((b-c).x ** 2 + (b-c).y ** 2) 
	var ca: float = sqrt((c-a).x ** 2 + (c-a).y ** 2)
	
	incentor = (bc*a + ca*b + ab*c) / (ab + bc + ca) 
	 
	return incentor
	
func _get_camera_offset() -> Vector2:
	# calculate camera offset
	var camera_offset: Vector2
	
	var bc_group: Array[Node] = pc_group.filter(func (pc: Node):
		return pc != current_pc)
	var mid_bc: Vector2 = (bc_group[0].global_position + bc_group[1].global_position) / 2
	camera_offset = (mid_bc - current_pc.global_position).normalized()
	
	return camera_offset
	
func _get_farthest_distance() -> float:
	# get farthest distance from current_pc
	var farthest_distance: float
	
	var pc_distances: Array[float]
	for pc: PlayableCharacter in pc_group:
		pc_distances.append(sqrt((current_pc.global_position-pc.global_position).x ** 2 + (current_pc.global_position-pc.global_position).y ** 2))
	pc_distances.sort()
	farthest_distance = pc_distances.back()
	
	return farthest_distance
	
func _set_current_pc(new_pc_index: int, new_pc: PlayableCharacter) -> void:
	# set current_pc_index + current_pc
	current_pc_index = new_pc_index
	current_pc = new_pc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# follow current_pc
	var current_pc_position: Vector2 = current_pc.global_position
	var incentor_position: Vector2 = _get_incentor_position()
	
	var screen_size: Vector2 = get_viewport_rect().size
	var farthest_distance: float = _get_farthest_distance()
	
	var offset: Vector2 = _get_camera_offset()
	global_position = (current_pc_position + incentor_position) / 2
	if farthest_distance > screen_size.x * 0.8 || farthest_distance > screen_size.y * 0.8:
		if global_position.distance_to(current_pc.global_position) < camera_move_speed:
			# adjust camera offset
			global_position += offset * camera_move_speed * delta
		if zoom > Vector2(0.8, 0.8):
			# adjust zoom (zoom out)
			zoom -= Vector2(camera_zoom_speed * delta, camera_zoom_speed * delta)
	elif farthest_distance > screen_size.x * 0.3 || farthest_distance > screen_size.y * 0.3:
		if global_position.distance_to(current_pc.global_position) < camera_move_speed:
			# adjust camera offset
			global_position += offset * camera_move_speed * delta
		if zoom < Vector2(1.5, 1.5):
			# adjust zoom (zoom in)
			zoom += Vector2(camera_zoom_speed * delta, camera_zoom_speed * delta)
	else:
		if zoom < Vector2(1.5, 1.5):
			# adjust zoom (zoom in)
			zoom += Vector2(camera_zoom_speed * delta, camera_zoom_speed * delta)
