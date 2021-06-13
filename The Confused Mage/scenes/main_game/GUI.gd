extends CanvasLayer

func _on_Play_finished_maze():
	var currentLevel = String(get_parent().level)
	var totalTime = String(get_parent().totalTime)
	get_node("NextLevelMenu/Menu/Level").set_text("Levels Completed: " + currentLevel)
	get_node("NextLevelMenu/Menu/Time").set_text("Total Time: " + totalTime)
	$NextLevelMenu.visible = true

func _on_NextLevelMenu_NextLevel_pressed():
	$NextLevelMenu.visible = false


