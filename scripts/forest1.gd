# File: scripts/Main.gd
extends Node2D

var enemy_names = ["enemy1", "enemy2", "enemy3", "enemy4", "enemy5", "enemy6", "enemy7", "enemy8", "enemy9", "enemy10"]
var enemies = []
var typed_text: String = ""

func _ready():
	# Ensure Timer node exists and configure it
	var timer_node = $Timer
	if timer_node:
		timer_node.wait_time = 10.0
		timer_node.connect("timeout", Callable(self, "_on_Timer_timeout"))
		timer_node.start()
	else:
		print("Error: Timer node not found!")

func _on_Timer_timeout():
	print("Timer timeout")
	if enemy_names.size() > 0:
		var enemy_name = enemy_names.pop_front()
		var enemy_scene = preload("res://scenes/enemy.tscn")
		var enemy_instance = enemy_scene.instantiate()  
		add_child(enemy_instance)
		enemy_instance.position = Vector2(0, 0) 
		enemy_instance.assign_name(enemy_name)  
		enemies.append(enemy_instance)
		print("Spawn enemy: " + enemy_name)
	else:
		$Timer.stop()

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var char = event.as_text()
		if is_alphanumeric(char):  
			typed_text += char.to_lower()  
			$TypedLabel.text = typed_text
			print("Typed: " + typed_text)
			check_enemy_names(typed_text)
		else:
			pass

func is_alphanumeric(char: String) -> bool:
	if char.length() != 1:
		return false
	var c = char[0]
	return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')

func check_enemy_names(input_name: String):
	var lower_input_name = input_name.to_lower()  
	for enemy in enemies:
		if enemy.enemy_name.to_lower() == lower_input_name:
			enemy.queue_free()
			enemies.erase(enemy)
			typed_text = ""  
			$TypedLabel.text = typed_text
			print("Enemy destroyed: " + input_name)
			break
