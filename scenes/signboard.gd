extends Node2D


@export var label_text: String
@onready var label = $Label
@onready var area2d = $Area2D

func _ready():
	# Set initial visibility to false
	self.visible = false
	label.text = label_text
	
	# Connect the signals for body entered and exited


func _on_area_2d_body_entered(body):
	if body.has_method( "player"):
		self.visible = true
		label.text = label_text


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		self.visible = false
