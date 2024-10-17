extends CharacterBody2D


const SPEED = 100
var curr_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$ProgressBar.value = health  # Initialize the health bar


func _physics_process(delta):
	player_movement(delta)
	current_camera()
	
func player():
	pass
	
func player_movement(_delta):
	
	if Input.is_action_pressed("ui_right"):
		curr_dir = "left"
		play_anim(1)
		velocity.x=SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		curr_dir = "right"
		play_anim(1)
		velocity.x=-SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		curr_dir = "up"
		play_anim(1)
		velocity.x=0
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		curr_dir = "down"
		play_anim(1)
		velocity.x=0
		velocity.y = SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = curr_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
			
func current_camera():
	if Global.current_scene == "world":
		$World_camera.enabled = true
		$forest_camera.enabled = false
	elif Global.current_scene == "forest":
		$World_camera.enabled = false
		$forest_camera.enabled = true
		
#func update_health():
#func _on_regin_timer_timeout():
	#pass # Replace with function body.

var health = 100  # Initial health
var max_health = 100

func _on_ProximityZone_body_entered(body):
	if body.is_in_group("enemies"):
		decrease_health(20)

func decrease_health(amount):
	health -= amount
	health = clamp(health, 0, max_health)  # Ensure health doesn't go below 0
	$TextureProgress.value = health  # Update the health bar

	if health == 0:
		print("Player is dead!")  # You can trigger a game over or respawn logic here



func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		decrease_health(20)# Replace with function body.
