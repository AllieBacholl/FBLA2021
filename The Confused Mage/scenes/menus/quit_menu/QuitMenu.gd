extends Control

signal Add_Score_pressed
signal Return_pressed

func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	emit_signal("Add_Score_pressed")

func _on_AddScoreButton_pressed():
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_ReturnButton_pressed():
	emit_signal("Return_pressed")

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/Exit.tscn")
