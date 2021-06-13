extends Control

var scene_path_to_load

# Called when the node enters the scene tree for the first time
func _ready():
	# Connects all buttons to _on_Button_pressed function
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	
# Sets the next scene to load based off of button and begins fade
func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

# Loads in scene once fade is finished
func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	get_tree().change_scene(scene_path_to_load)

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
