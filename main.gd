# credits
	# NYKNCK - Pixel Art Effect - FX084 https://nyknck.itch.io/fx084
	# NYKNCK - Pixel Art Effect - FX010 https://nyknck.itch.io/pixel-art-effectfx010
	# NYKNCK - Pixel Explosion - https://nyknck.itch.io/explosion
	# NYKNCK - Effect - https://nyknck.itch.io/effectnpt
	# NYKNCK - Effect - https://nyknck.itch.io/effectlt
	# NYKNCK - Free FX - Pixel Art Effect - FX062 - https://nyknck.itch.io/fx062
	# AxulArt - Small 8-direction Characters https://axulart.itch.io/small-8-direction-characters
	# 0x72 - 16x16 DungeonTileset II - https://0x72.itch.io/dungeontileset-ii
	# Poppy Works - Silver font https://poppyworks.itch.io/silver

extends Node

# enemy spawn
@onready var enemy_ps: PackedScene = preload("res://enemy/enemy.tscn")
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
#bottle spawn
@onready var bottle_spawn_areas: Array[Node] = get_tree().get_nodes_in_group("bottle_spawn_areas")
@onready var bottle_ps: PackedScene = preload("res://actions/environment actions/furnitures/bottle/Bottle.tscn")


func _ready() -> void:
	# spawn enemies
	for i in range(10):
		var enemy: Character = enemy_ps.instantiate()
		enemy.global_position = Vector2(500,400)
		enemy.add_to_group("enemy")
		get_node("Enemies").add_child(enemy)
	
	# TODO: create bottles
	for b_area: InteractionArea in bottle_spawn_areas:
		var bottle: Action = bottle_ps.instantiate() as Action
		await b_area._add_bottle(bottle)

func _on_enemy_spawn_timer_timeout():
	# spawn new enemy
	var enemy: Character = enemy_ps.instantiate()
	enemy.global_position = Vector2(500,400)
	enemy.add_to_group("enemy")
	get_node("Enemies").add_child(enemy)
