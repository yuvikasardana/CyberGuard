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
	queue_text("Excuse me wanderer where can I find the bathroom?")
	queue_text("Why do we not look like the others?")
	queue_text("Because we are free assets from opengameart!")
	queue_text("Thanks for watching!")


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



