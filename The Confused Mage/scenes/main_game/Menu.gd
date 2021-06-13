extends CanvasLayer

func _on_Play_finished_maze():
	$AudioStreamPlayerNextLevel.play()
	var completedLevels = String(get_parent().level - 1)
	var totalTime = String(get_parent().totalTime)
	var hearts_left = get_parent().totalHearts
	get_node("NextLevelMenu/Menu/Level").set_text("Levels Completed: " + completedLevels)
	get_node("NextLevelMenu/Menu/Time").set_text("Total Time: " + totalTime)
	get_node("NextLevelMenu/Menu/Hearts").refresh_hearts(hearts_left)
	$NextLevelMenu.visible = true

func _on_NextLevelMenu_NextLevel_pressed():
	$NextLevelMenu.visible = false
	get_parent().start_timer()
	get_parent().enable_control()

func _on_Play_Mage_death():
	var completedLevels = String(get_parent().level - 1)
	var totalTime = String(get_parent().totalTime)
	var hearts_left = get_parent().totalHearts
	get_node("DiedMenu/Menu/Level").set_text("Levels Completed: " + completedLevels)
	get_node("DiedMenu/Menu/Time").set_text("Total Time: " + totalTime)
	get_node("DiedMenu/Menu/Hearts").refresh_hearts(hearts_left)
	$DiedMenu.visible = true
	
func _on_Play_Game_over():
	var completedLevels = String(get_parent().level - 1)
	var totalTime = String(get_parent().totalTime)
	get_node("GameOverMenu/Menu/Level").set_text("Levels Completed: " + completedLevels)
	get_node("GameOverMenu/Menu/Time").set_text("Total Time: " + totalTime)
	$GameOverMenu.visible = true

func _on_DiedMenu_Retry_pressed():
	$DiedMenu.visible = false
	get_parent().start_timer()
	get_parent().enable_control()

func _on_GameOverMenu_Scoreboard_pressed():
	$EnterNameMenu.visible = true

func _on_GameOverMenu_Quit_pressed():
	$QuitMenu.visible = true

func _on_DiedMenu_Quit_pressed():
	$QuitMenu.visible = true

func _on_QuitMenu_Add_Score_pressed():
	$QuitMenu.visible = false
	$EnterNameMenu.visible = true

func _on_QuitMenu_Return_pressed():
	$QuitMenu.visible = false

func _on_NextLevelMenu_Quit_pressed():
	$QuitMenu.visible = true

func _on_EnterNameMenu_Continue_pressed():
	var completedLevels = String(get_parent().level - 1)
	var totalTime = String(get_parent().totalTime)
	var playerName = $EnterNameMenu.get_name().to_upper()
	var dict = {
		"level_reached":completedLevels,
		"name":playerName,
		"total_time":totalTime,
	}
	var file = File.new()
	
	if file.open("res://scenes/scoreboard/scoreboard.json", File.READ_WRITE) != OK:
		return
	file.seek_end(-6)
	file.store_line("\n	" + to_json(dict) + ",\n" +
					"	]\n" +
					"}")
	file.close()
