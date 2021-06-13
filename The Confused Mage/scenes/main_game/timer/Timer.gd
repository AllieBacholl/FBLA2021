extends Node2D

signal Times_out

var totalTime = "00:00"
var timeLeft = "00:15"
var totalSeconds = 0
var secondsLeft = 10

func _ready():
	$Timer.set_wait_time(1)
	$Timer.start()
	timeLeft = ("%02d" % int(secondsLeft / 60 )) + (":%02d" % (secondsLeft % 60))
	$Time.set_text(timeLeft)

func _on_Timer_timeout():
	totalSeconds += 1
	secondsLeft -= 1
	timeLeft = ("%02d" % int(secondsLeft / 60 )) + (":%02d" % (secondsLeft % 60))
	$Time.set_text(timeLeft)
	if secondsLeft == 0:
		emit_signal("Times_out")

func get_total_time():
	totalTime = ("%02d" % int(totalSeconds / 60 )) + (":%02d" % (totalSeconds % 60))
	return totalTime
