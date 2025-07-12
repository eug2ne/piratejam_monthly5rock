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

extends Node2D

# enemy spawn
@onready var enemy_ps: PackedScene = preload("res://enemy/enemy.tscn")
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func _ready() -> void:
	# load managers
	PlayerManager._load()
	
	# BUG: enemy spawn having collision issues?
	# spawn enemies
	for i in range(10):
		var enemy: Character = enemy_ps.instantiate()
		enemy.global_position = Vector2(500,400)
		enemy.add_to_group("enemy")
		get_node("Enemies").add_child(enemy)

func _on_enemy_spawn_timer_timeout():
	# spawn new enemies
	for i in range(5):
		var enemy: Character = enemy_ps.instantiate()
		enemy.global_position = Vector2(500,400)
		enemy.add_to_group("enemy")
		get_node("Enemies").add_child(enemy)
		print(enemy)
