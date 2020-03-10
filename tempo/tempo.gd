extends Node
class_name Tempo, "res://tempo/tempo.png"

"""
Tempo algorithm. Sends a tempo data dictionary on each beat (1/8 at the moment).

- measure sound and quart sound play at the same time each measure, but not beats ?
- refactor counting system : down to 1/16 or 1/32
- rename bar names : quart is bar, syncope is dot, add sixteenth and thirtysecond maybe
- add absolute time in tempo dict
- change from binary to ternary needs tempo restart
- add bgm test ?
- tempo isn't a custom node (maybe not needed), needs to be instanced to work
- think about how multiple scenes inherit the same synced tempo data
- think of a data structure to define moments in song, ex: s2_m4_b2_d (section 2, measure 4, bar 2, dot)
"""

signal on_tempo

export var bpm := 120
export var all_beats_sound := true
export var measure_sound := false
export var quart_sound := false
export var syncope_sound := false
export (int, "Binary", "Ternary") var signature_type

onready var clic_01 := $Clic_01
onready var clic_02 := $Clic_02
onready var timer := $Timer
onready var play_btn := $PlayButton

var counter := 1.0
var signature := 0.0
var tempo := {
	"bpm": null,
	"is_full": false,
	"is_quart": false,
	"is_syncope": false,
	"is_eight": false,
	"measure_count": 1,
	"quart_count": 1,
	"syncope_count": 1.5,
	"beat_count": 1
}

func _on_PlayButton_toggled(button_pressed):
	if button_pressed: 
		start_timer()
		play_btn.text = "Stop"
	else: 
		stop_timer()
		play_btn.text = "Start"

func _on_Timer_timeout() -> void:
	play_beat()
	
	if counter == signature:
		play_measure()
		reset_measure()
	else:
		counter += .5
		tempo.is_full = false
		tempo.beat_count += 1
	
	if step_decimals(counter) > 0:  # Detects if counter is float (syncope) or integer (quart)
		tempo.is_quart = false
		tempo.is_syncope = true
		tempo.syncope_count = counter
		play_syncope()
	else:
		tempo.is_quart = true
		tempo.is_syncope = false
		tempo.quart_count = counter
		play_quart()
	
	emit_signal("on_tempo", tempo)
	print(tempo)
	timer.start()

func start_timer() -> void:
	timer.wait_time = 60.0 / (bpm * 2)
	timer.start()
	
	play_beat()
	play_measure()
	play_quart()
	
	signature = 4.5 if signature_type == 0 else 3.5
	tempo.bpm = bpm
	tempo.is_quart = true
	tempo.is_eight= true
	emit_signal("on_tempo", tempo)
	print(tempo)

func stop_timer() -> void:
	timer.stop()
#	if debug_bgm: bgm.stop()
	reset_tempo_dict()
	counter = 1.0

func reset_measure() -> void:
	counter = 1
	tempo.beat_count = 1
	tempo.measure_count += 1
	tempo.is_full = true

func reset_tempo_dict() -> void:
	tempo.bpm = null
	tempo.is_full = false
	tempo.is_quart = false
	tempo.is_syncope = false
	tempo.is_eight= false
	tempo.measure_count = 1
	tempo.quart_count = 1
	tempo.syncope_count = 1.5
	tempo.beat_count = 1

func play_beat() -> void:
	if all_beats_sound:
		clic_01.pitch_scale = 1
		clic_01.volume_db = -20
		clic_01.play()

func play_measure() -> void:
	if measure_sound:
		clic_01.pitch_scale = 1.2
		clic_01.volume_db = -5
		clic_01.play()

func play_quart() -> void:
	if quart_sound:
		clic_02.pitch_scale = .8
		clic_02.volume_db = -10
		clic_02.play()

func play_syncope() -> void:
	if syncope_sound:
		clic_01.pitch_scale = .6
		clic_01.volume_db = -20
		clic_01.play()
