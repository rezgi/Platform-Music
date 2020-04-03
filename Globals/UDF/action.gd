extends Node

#func game_set_start_time(time: int) -> Dictionary:
#	return {
#		type = "GAME_SET_START_TIME",
#		time = time
#	}
#
#func player_set_name(name: String) -> Dictionary:
#	return {
#		type = "PLAYER_SET_NAME",
#		name = name
#	}
#
#func player_set_health(health: int) -> Dictionary:
#	return {
#		type = "PLAYER_SET_HEALTH",
#		health = health
#	}

func metronome_check_input(status: bool) -> Dictionary:
	return {
		type = "INPUT_ERROR",
		status = status
	}
