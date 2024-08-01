extends Node2D

var enemy_names_level_1 = ["ip1", "ip2", "ip3", "ip4", "ip5", "ip6", "ip7", "ip8", "ip9", "ip10"]
var enemy_names_level_2 = ["ip11", "ip12", "ip13", "ip14", "ip15", "ip16", "ip17", "ip18", "ip19", "ip20", "ip21", "ip22", "ip23", "ip24", "ip25"]
var enemy_names_level_3 = ["ip26", "ip27", "ip28", "ip29", "ip30", "ip31", "ip32", "ip33", "ip34", "ip35", "ip36", "ip37", "ip38", "ip39", "ip40"]

var enemies = []
var typed_text: String = ""
var current_level = 1
var timer_node
var enemy_names

# Define the boundaries of the map
var map_min_y = 100
var map_max_y = 1000

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
		
		# Randomly decide whether the enemy comes from the left or right
		var side = randi() % 2  # 0 or 1
		var random_y = map_min_y + randf() * (map_max_y - map_min_y)
		var position = Vector2()
		
		if side == 0:
			# Spawn enemy from the left
			position = Vector2(0, random_y)
		else:
			# Spawn enemy from the right
			position = Vector2(get_viewport().size.x, random_y)
		
		enemy_instance.position = position

		add_child(enemy_instance)
		enemy_instance.assign_name(enemy_name)
		enemies.append(enemy_instance)
	else:
		timer_node.stop()
		current_level += 1
		if current_level <= 3:
			start_level(current_level)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			# Remove the last character from typed_text if not empty
			if typed_text.length() > 0:
				typed_text = typed_text.substr(0, typed_text.length() - 1)
				$TypedLabel.text = typed_text
		else:
			# Handle alphanumeric input
			var char = event.as_text()
			if is_alphanumeric(char):
				typed_text += char.to_lower()
				$TypedLabel.text = typed_text
				check_enemy_names(typed_text)


func is_alphanumeric(char: String) -> bool:
	if char.length() != 1:
		return false
	var c = char[0]
	return (c >= '0' and c <= '9') or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c == '.')

func check_enemy_names(input_name: String):
	var lower_input_name = input_name.to_lower()
	for enemy in enemies:
		if enemy.enemy_name.to_lower() == lower_input_name:
			enemy.queue_free()
			enemies.erase(enemy)
			typed_text = ""  
			$TypedLabel.text = typed_text
			break


func _on_textbox_textboxes_completed():
	start_level(current_level)
