# File: scripts/Main.gd
extends Node2D

var enemy_names_level_1 = ["192.168.0.1", "192.168.1.2", "192.168.2.3", "192.168.3.4", "192.168.4.5", "178.128.10.31", "178.128.11.32", "178.128.12.33", "178.128.13.34", "178.128.14.35"]
var enemy_names_level_2 = ["192.168.5.6", "192.168.6.7", "192.168.7.8", "192.168.8.9", "192.168.9.10", "178.128.10.31", "178.128.11.32", "178.128.12.33", "178.128.13.34", "178.128.14.35", "192.168.15.16", "192.168.16.17", "192.168.17.18", "192.168.18.19", "192.168.19.20"]
var enemy_names_level_3 = [ "178.128.5.26", "178.128.6.27", "178.128.7.28", "178.128.8.29", "178.128.9.30", "192.168.15.16", "192.168.16.17", "192.168.17.18", "192.168.18.19", "192.168.19.20", "178.128.0.21", "178.128.1.22", "178.128.2.23", "178.128.3.24"]

var enemies = []
var typed_text: String = ""
var current_level = 1
var timer_node
var enemy_names
var textbox_script

func _ready():
	timer_node = $Timer
	

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
		if event.as_text_key_label()== ".":
			typed_text += event.as_text_key_label() 
		else:
			var ch = event.as_text()
			if ch in [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
				typed_text += ch
			#.to_lower()
				$TypedLabel.text = typed_text
				check_enemy_names(typed_text)

##func is_alphanumeric(ch: String) -> bool:
	##if ch == ".":
		##return true
	#if ch.length() != 1:
		#return false
	#var c = ch[0]
	#return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')


func check_enemy_names(input_name: String):
	var lower_input_name = input_name #to_lower()
	for enemy in enemies:
		if enemy.enemy_name == lower_input_name:
			#to_lower()
			enemy.queue_free()
			enemies.erase(enemy)
			typed_text = ""  
			$TypedLabel.text = typed_text
			break




func _on_textbox_textboxes_completed():
	start_level(current_level)
