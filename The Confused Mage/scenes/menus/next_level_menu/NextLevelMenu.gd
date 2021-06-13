extends Control

signal NextLevel_pressed
signal Quit_pressed

var scene_path_to_load

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	emit_signal("NextLevel_pressed")

func _on_NextLevel_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_QuitButton_pressed():
	emit_signal("Quit_pressed")
