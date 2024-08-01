# File: scripts/Enemy.gd
extends CharacterBody2D

var enemy_name: String
var speed: float = 50.0  # Speed at which the enemy will move

func _ready():
	$Label.text = enemy_name
	set_process(true)  # Ensure the process function is called every frame

func assign_name(name: String):
	enemy_name = name
	$Label.text = enemy_name

func _process(delta):
	var main_character = get_parent().get_node("player")
	if main_character:
		var direction = (main_character.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
