extends InteractionArea

var bottle: Action

func _ready():
	action_name = "throw"
	interact = _throw_bottle

func _add_bottle(new_bottle: Action):
	add_child(new_bottle)
	bottle = new_bottle
	bottle.animatable_body.global_position = global_position

func _throw_bottle():
	# disable spawn area
	_set_action_available(false)
	
	# set bottle parent to current_pc
	var current_player: PlayableCharacter = PlayerManager.current_pc
	bottle.parent = current_player
	# throw bottle
	bottle._throw()
