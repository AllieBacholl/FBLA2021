extends Control

signal Quit_pressed
signal Retry_pressed

var scene_path_to_load

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	emit_signal("Retry_pressed")

func _on_RetryButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_QuitButton_pressed():
	emit_signal("Quit_pressed")
