extends KinematicBody2D

signal Game_over
signal Mage_death
signal Animation_finished
signal collided

export var speed = 200  # How fast the player will move (pixels/sec).
export (float) var rotation_speed = 1.5

var screen_size  # Size of the game window.
var start_pos = Vector2(20, 20)
var has_control = true # If the player has control
var hearts_left = 3
onready var animated_heart = get_node("Camera2D/AnimatedHeart")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Camera2D.zoom = Vector2(0.25, 0.25)
	move_to_start()
	get_node("Camera2D/Hearts").refresh_hearts(hearts_left)
	has_control = true

var velocity = Vector2()  # The player's movement vector.

# Moves mage and playes animations based on buttons the player presses
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity = Vector2(speed, 0)
		$AnimatedSprite.set_rotation(PI/2)
	if Input.is_action_pressed("ui_left"):
		velocity = Vector2(-speed, 0)
		$AnimatedSprite.set_rotation((3*PI)/2)
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2(0, speed)
		$AnimatedSprite.set_rotation(PI)
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2(0, -speed)
		$AnimatedSprite.set_rotation(0)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.set_animation("moving")
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.set_animation("stopped")
		$AnimatedSprite.play()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if has_control == true:
		get_input()
	else:
		velocity = Vector2(0, 0)
		$AnimatedSprite.set_animation("stopped")
		$AnimatedSprite.play()
		
	move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal("collided", collision)
	
func _on_Timer_Times_out():
	hearts_left -= 1
	if hearts_left == 0:
		emit_signal("Game_over")
	else:
		emit_signal("Mage_death")
		
func move_to_start():
	speed = 200
	$Camera2D.zoom = Vector2(0.25, 0.25)
	has_control = false
	set_position(start_pos)
	
	
func lose_life():
	has_control = false
	if hearts_left == 2:
		get_node("Camera2D/Hearts/Heart3").frame = 4
	if hearts_left == 1:
		get_node("Camera2D/Hearts/Heart2").frame = 4
	if hearts_left == 0:
		get_node("Camera2D/Hearts/Heart1").frame = 4
	animated_heart.set_animation("losing")
	animated_heart.visible = true
	animated_heart.play()
	get_node("Camera2D/Hearts").refresh_hearts(hearts_left)
	
func _on_AnimatedHeart_animation_finished():
	animated_heart.stop()
	get_node("Camera2D/AnimatedHeart").visible = false
	emit_signal("Animation_finished")
	
func speed_up(level):
	speed = 300 # 50% increase in speed
	$SpeedTimer.set_wait_time(5 + level)
	$SpeedTimer.start()

func _on_SpeedTimer_timeout():
	speed = 200
	
func add_heart():
	if hearts_left < 3:
		hearts_left += 1
		get_node("Camera2D/Hearts").refresh_hearts(hearts_left)

func zoom_out(level): 
	$Camera2D.zoom = Vector2(0.5, 0.5) # 100% zoom out
	$ZoomTimer.set_wait_time(2 + level)
	$ZoomTimer.start()

func _on_ZoomTimer_timeout():
	$Camera2D.zoom = Vector2(0.25, 0.25)
