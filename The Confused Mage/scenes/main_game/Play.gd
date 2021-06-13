extends Node2D

signal finished_maze
signal Mage_death
signal Game_over

var level = 1
var totalTime
var secondsLeft
var totalHearts

func _on_Mage_collided(collision):
	if collision.collider is TileMap:
		var tile_pos = $Maze.get_tile_pos($Mage.position)
		if tile_pos == $Maze.end:
			stop_timer()
			totalTime = get_node("Mage/Camera2D/Timer").get_total_time()
			totalHearts = $Mage.hearts_left
			level += 1
			$Maze.make_maze()
			$Mage.move_to_start()
			emit_signal("finished_maze")
		for x in $Maze.powerUps:
			var powerUp
			if tile_pos == x:
				powerUp = $Maze.get_power_type(tile_pos)
				if powerUp == 4: # more time
					var addedTime = 5 + level
					get_node("Mage/Camera2D/Timer").secondsLeft += addedTime
					$AudioStreamPlayerPowerUp.play()
				if powerUp == 5: # speed
					$Mage.speed_up(level)
					$AudioStreamPlayerPowerUp.play()
				if powerUp == 6: # another heart
					$Mage.add_heart() # maybe add animation in upper right
					$AudioStreamPlayerPowerUp.play()
				if powerUp == 7: # zoom out
					$Mage.zoom_out(level)
					$AudioStreamPlayerPowerUp.play()
				get_node("Maze/OverlayTiles").set_cellv(x, -1)
				

func start_timer():
	secondsLeft = int(pow(level, 2) + 9)
	get_node("Mage/Camera2D/Timer/Time").set_text(("%02d" % int(secondsLeft / 60 )) + (":%02d" % (secondsLeft % 60)))
	get_node("Mage/Camera2D/Timer").secondsLeft = secondsLeft
	get_node("Mage/Camera2D/Timer/Timer").start()

func enable_control():
	$Mage.has_control = true

func stop_timer():
	get_node("Mage/Camera2D/Timer/Timer").stop()

func _on_Mage_Mage_death():
	stop_timer()
	$AudioStreamPlayerDeath.play()
	$Mage.lose_life()
	
func _on_Mage_Animation_finished():
	totalTime = get_node("Mage/Camera2D/Timer").get_total_time()
	totalHearts = $Mage.hearts_left
	$Maze.make_maze()
	$Mage.move_to_start()
	emit_signal("Mage_death")

func _on_Mage_Game_over():
	stop_timer()
	$Mage.lose_life()
	yield(get_tree().create_timer(1.0), "timeout")
	totalTime = get_node("Mage/Camera2D/Timer").get_total_time()
	emit_signal("Game_over")

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
