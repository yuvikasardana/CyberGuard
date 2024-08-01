extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label3
@onready var tween = get_tree().create_tween()
const CHAR_READ_RATE = 0.05

enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox() # Replace with function body.
	if(Global.current_scene == "world"):
		queue_text("Welcome to the kingdom of cyber land")
		queue_text("Give instructions to your guard to protect your kingdom from bandits")
		queue_text("The kingdom is divided into three areas for you to protect ")
		queue_text("For the prototype version only firewall forest is active")
		queue_text("Explore the area and find your way to the firewall forest to protect your kingdom from being infilterated by bandits")
		queue_text("All The Best!")
	if(Global.current_scene =="forest"):
		queue_text("You have reached the firewall forest")
		queue_text("This forest imitates setting up a firewall to protect your system from unwanted access")
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.READY:
			if text_queue.size():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.kill()
				label.visible_characters = -1
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
			
func hide_textbox():
	label.text = ""
	textbox_container.hide()

func queue_text(next_text):
	text_queue.push_back(next_text)
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

	
func show_textbox():
	textbox_container.show()
	
func display_text():
	tween = get_tree().create_tween()
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	change_state(State.FINISHED)



