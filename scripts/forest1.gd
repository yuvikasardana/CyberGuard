# File: scripts/Main.gd
extends Node2D

var enemy_names_level_1 = ["enemy1", "enemy2", "enemy3", "enemy4", "enemy5", "enemy6", "enemy7", "enemy8", "enemy9", "enemy10"]
var enemy_names_level_2 = ["enemy11", "enemy12", "enemy13", "enemy14", "enemy15", "enemy16", "enemy17", "enemy18", "enemy19", "enemy20", "enemy21", "enemy22", "enemy23", "enemy24", "enemy25"]
var enemy_names_level_3 = ["enemy26", "enemy27", "enemy28", "enemy29", "enemy30", "enemy31", "enemy32", "enemy33", "enemy34", "enemy35", "enemy36", "enemy37", "enemy38", "enemy39", "enemy40"]

var enemies = []
var typed_text: String = ""
var current_level = 1
var timer_node
var enemy_names

func _ready():
	timer_node = $Timer
	start_level(current_level)

func start_level(level):
	match level:
		1:
			enemy_names = enemy_names_level_1.duplicate()
			timer_node.wait_time = 6.0
		2:
			enemy_names = enemy_names_level_2.duplicate()
			timer_node.wait_time = 4.0
		3:
			enemy_names = enemy_names_level_3.duplicate()
			timer_node.wait_time = 3.0
	timer_node.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer_node.start()

func _on_Timer_timeout():
	if enemy_names.size() > 0:
		var enemy_name = enemy_names.pop_front()
		var enemy_scene = preload("res://scenes/enemy.tscn")
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.position = Vector2(0, 0)  
		enemy_instance.assign_name(enemy_name)
		enemies.append(enemy_instance)
	else:
		timer_node.stop()
		current_level += 1
		if current_level <= 3:
			start_level(current_level)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var char = event.as_text()
		if is_alphanumeric(char):
			typed_text += char.to_lower()
			$TypedLabel.text = typed_text
			check_enemy_names(typed_text)

func is_alphanumeric(char: String) -> bool:
	if char.length() != 1:
		return false
	var c = char[0]
	return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c=='.')

func check_enemy_names(input_name: String):
	var lower_input_name = input_name.to_lower()
	for enemy in enemies:
		if enemy.enemy_name.to_lower() == lower_input_name:
			enemy.queue_free()
			enemies.erase(enemy)
			typed_text = ""  
			$TypedLabel.text = typed_text
			break


