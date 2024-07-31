extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	hide_buttons()

func resume():
	get_tree().paused= false
	$AnimationPlayer.play_backwards("blur")
	hide_buttons()
	
func pause():
	get_tree().paused= true
	$AnimationPlayer.play("blur")
	show_buttons()
	
func testEsc():
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

func _process(_delta):
	testEsc()
	
# Helper function to show the buttons
func show_buttons():
	$resume.show()
	$restart.show()
	$quit.show()

# Helper function to hide the buttons
func hide_buttons():
	$resume.hide()
	$restart.hide()
	$quit.hide()
	print("Hiding buttons")
	
	


 
