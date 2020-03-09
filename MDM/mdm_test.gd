extends Node

onready var mdm := $MixingDeskMusic

func _ready():
	mdm.init_song("main_riff_01")
	mdm.play("main_riff_01")
