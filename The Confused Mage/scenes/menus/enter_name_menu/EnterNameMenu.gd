extends Control

signal Continue_pressed

var playerName

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	get_tree().change_scene("res://scenes/scoreboard/ScoreboardMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/Exit.tscn")

func _on_ContinueButton_pressed():
	playerName = get_node("Menu/LineEdit").get_text()
	
	var regexName = RegEx.new()
	regexName.compile("([A-Z]|[a-z]){3}")
	var result = regexName.search_all(playerName)
	
	if playerName.length() > 3:
		 get_node("Menu/MaxChar").set_text("Your name can only be\nthree letters long!")
	elif result.size() == 0:
		get_node("Menu/MaxChar").set_text("Only use letters, no numbers\nor special characters!")
	else:
		emit_signal("Continue_pressed")
		$FadeIn.show()
		$FadeIn.fade_in()

func get_name():
	return playerName
