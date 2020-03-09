extends Node

onready var mdm := $MixingDeskMusic
var current_song := 0
var is_playing := false

func _ready():
	mdm.init_song(current_song)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and not is_playing:
		mdm.play(current_song)
		is_playing = true
	
	if Input.is_action_just_pressed("ui_cancel") and is_playing:
		mdm.stop(current_song)
		is_playing = false
		current_song = 0
	
	if Input.is_action_just_pressed("ui_up") and is_playing:
		current_song += 1
		mdm.queue_bar_transition(current_song)

func _on_MixingDeskMusic_bar(bar : int):
	print("bar : %s" % bar)

func _on_MixingDeskMusic_beat(beat : int):
	print("beat : %s" % beat)

func _on_MixingDeskMusic_end(song_num : int):
	print("end : %s" % song_num)

func _on_MixingDeskMusic_shuffle(old_song_num : int, new_song_num : int):
	print("shuffle from %s to %s" % [old_song_num, new_song_num])

func _on_MixingDeskMusic_song_changed(old_song_num : int, new_song_num : int):
	print("changed from %s to %s" % [old_song_num, new_song_num])

#queue_beat_transition(song) or queue_bar_transition(song)
