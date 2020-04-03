extends Node

func _ready() -> void:
	data.create([
		{'name': 'game', 'instance': reducers},
		{'name': 'player', 'instance': reducers},
		{'name': 'metronome', 'instance': reducers}
	], [
		{'name': '_on_data_changed', 'instance': self}
	])

#	data.send(action.game_set_start_time(OS.get_unix_time()))
#	data.send(action.player_set_name('Amine'))
#	data.send(action.player_set_health(100))

func _on_data_changed(_name : String, _state: Dictionary) -> void:
	print("%s : %s" % [_name, _state])
