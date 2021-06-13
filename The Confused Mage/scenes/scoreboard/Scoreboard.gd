extends Node

var top_ten_scores = []
var all_scores = []

func _ready():
	var loaded_file = load_json_file("res://scenes/scoreboard/scoreboard.json")
	parse_file(loaded_file)
	sort_scores(all_scores)
	create_scoreboard()

func load_json_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var loaded_file = result_json.result
	return loaded_file
	
func parse_file(loaded_file):
	var level = []
	var name = []
	var total_time = []
	var data = str(loaded_file)
	var regexLevel = RegEx.new()
	regexLevel.compile("level_reached([:])([0-9])+")
	var regexTime = RegEx.new()
	regexTime.compile("total_time([:])([0-9]+[:][0-9]+)")
	var regexName = RegEx.new()
	regexName.compile("name([:])([A-Z]+|[a-z])+")
	
	var result = regexLevel.search_all(data)
	for i in result.size():
		level.append(result[i].get_string().substr(14))
	
	result = regexTime.search_all(data)
	for i in result.size():
		total_time.append(result[i].get_string().substr(11))
	
	result = regexName.search_all(data)
	for i in result.size():
		name.append(result[i].get_string().substr(5))
		

	for x in level.size():
		all_scores.append([])
		for y in 3:
			all_scores[x].append([])
		all_scores[x][0].append(level[x])
		all_scores[x][1].append(total_time[x])
		all_scores[x][2].append(name[x])
	
func sort_scores(all_scores):
	var moves = 1
	var temp
	while moves > 0:
		moves = 0
		for x in all_scores.size() - 1:
			if int(all_scores[x][0][0]) < int(all_scores[x+1][0][0]):
				temp = all_scores[x]
				all_scores[x] = all_scores[x+1]
				all_scores[x+1] = temp
				moves += 1
			elif all_scores[x][0][0] == all_scores[x+1][0][0]:
				var alphabeticallOrder = all_scores[x][2][0].casecmp_to(all_scores[x+1][2][0])
				if to_seconds(all_scores[x][1][0]) > to_seconds(all_scores[x+1][1][0]):
					temp = all_scores[x]
					all_scores[x] = all_scores[x+1]
					all_scores[x+1] = temp
					moves += 1
				elif to_seconds(all_scores[x][1][0]) == to_seconds(all_scores[x+1][1][0]) && alphabeticallOrder == 1:
					temp = all_scores[x]
					all_scores[x] = all_scores[x+1]
					all_scores[x+1] = temp
					moves += 1
			
func to_seconds(time):
	var regexMinutes = RegEx.new()
	regexMinutes.compile("([0-9]\\d[:][0-9]\\d)")
	var regexSeconds = RegEx.new()
	regexSeconds.compile("([:][0-9]\\d)")
	
	var minutes
	var seconds 
	var totalSeconds
	
	var result = regexMinutes.search_all(time)
	for i in result.size():
		minutes = int(result[i].get_string())
	
	result = regexSeconds.search_all(time)
	for i in result.size():
		seconds = int(result[i].get_string().substr(1))
		
	totalSeconds = (minutes * 60) + seconds
	return totalSeconds

func create_scoreboard():
	var gridLeft = get_node("Menu/HBoxContainer/GridContainerLeft")
	var gridRight = get_node("Menu/HBoxContainer/GridContainerRight")
	var lable
	var max_x = all_scores.size()
	
	for x in 10:
		for y in 3:
			lable = Label.new()
			if x < 5:
				gridLeft.add_child(lable, true)
			else:
				gridRight.add_child(lable, true)
			if x >= max_x:
				lable.text = "-"
			else:
				lable.text = all_scores[x][y][0]
			if y == 0:
				lable.add_color_override("font_color", Color("#00c4ac"))


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/menus/title_screen/TitleScreen.tscn")

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/Exit.tscn")

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
