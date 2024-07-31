extends CharacterBody2D

var enemy_name: String

func _ready():
	$Label.text = enemy_name

func assign_name(name: String):
	enemy_name = name
	$Label.text = enemy_name
