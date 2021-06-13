extends Node2D

func refresh_hearts(hearts_left):
	$Heart1.frame = 0
	$Heart2.frame = 0
	$Heart3.frame = 0
	
	if hearts_left >= 1:
		$Heart1.frame = 4
	if hearts_left >= 2:
		$Heart2.frame = 4
	if hearts_left == 3:
		$Heart3.frame = 4

func lose_life(hearts_left):
	if hearts_left == 2:
		$Heart3.frame = 0
	if hearts_left == 1:
		$Heart2.frame = 0
		
func gain_life(hearts_left):
	if hearts_left == 2:
		$Heart2.frame = 4
	if hearts_left == 3:
		$Heart3.frame = 4
