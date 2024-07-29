extends Node2D

const ForestScene = "res://scenes/forest.tscn"

func _ready():
	#$forest_entry.body_entered.connect(_on_forest_entry_body_entered)
	pass
	
func _process(delta):
	change_scene()

func _on_forest_entry_body_entered(body):
	print("detected")
	if body.has_method("player"):
		print("deteced again")
		Global.transition_scene = true
		
		


func _on_forest_entry_body_exited(body):
	if body.has_method("player"):
		Global.transition_scene = true
		
func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/forest.tscn")
			Global.finish_changescenes()
		




