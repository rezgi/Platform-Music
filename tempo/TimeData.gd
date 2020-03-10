extends Node

onready var line_edit := $CenterContainer/VBoxContainer/LineEdit
onready var btn := $CenterContainer/VBoxContainer/Button
onready var label := $CenterContainer/VBoxContainer/Label
onready var timer := $Timer
onready var clic := $AudioStreamPlayer
onready var anim := $AnimationPlayer

var bpm := 0
var time_before := 0.0
var time_now := 0.0
var bpm2time := 0.0

func _physics_process(_delta: float) -> void:
	if btn.pressed:
		time_now = (OS.get_ticks_msec() - time_before) / 1000.0
#		print(time_now)
		if time_now >= bpm2time:
			print("OS time : ", time_now)
			time_before = time_now

func _on_Timer_timeout():
#	clic.play()
#	anim.play("blink")
	time_now = OS.get_ticks_msec()
#	label.text = str(time_now - time_before)
	label.text = str(bpm2time)
#	print(time_now - time_before)
	time_before = time_now

func _on_Button_toggled(button_pressed):
	if button_pressed:
		bpm = int(line_edit.text)
		btn.text = "Stop"
		bpm2time = 60.0 / (bpm * 4)		# sixteenth note
		label.text = str(bpm2time)
		time_before = OS.get_ticks_msec()
		print("start time : ", time_before)
#		start_timer()
	else: 
#		stop_timer()
		btn.text = "Start"

func start_timer():
	time_before = OS.get_ticks_msec()
	timer.wait_time = bpm2time
	timer.start()
#	anim.play("blink")
#	clic.play()

func stop_timer():
	timer.stop()
