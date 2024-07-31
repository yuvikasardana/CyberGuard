extends Node2D

const ForestScene = "res://scenes/forest1.tscn"

func _ready():
	#$forest_entry.body_entered.connect(_on_forest_entry_body_entered)
	pass
	
func _process(delta):
	change_scene()

func _on_forest_entry_body_entered(body):
	#print(Global.current_screen)
	if body.has_method("player"):
		Global.transition_scene = true
		
		


func _on_forest_entry_body_exited(body):
	#print(Global.current_screen)
	if body.has_method("player"):
		Global.transition_scene = true
		
func change_scene():
	
	if Global.transition_scene == true:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/forest1.tscn")
			Global.finish_changescenes()
		




