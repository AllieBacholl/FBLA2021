extends Control

signal Quit_pressed
signal Scoreboard_pressed

var scene_path_to_load

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	emit_signal("Scoreboard_pressed")

func _on_ScoreboardButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_QuitButton_pressed():
	emit_signal("Quit_pressed")
