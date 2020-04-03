extends Node

# Utility functions

func type(type: String, action: Dictionary) -> bool:
	return true if action.type == type else false

func new_state(name: String, action: Dictionary, state: Dictionary, new_name: String = "") -> Dictionary:
	var next_state := data.shallow_copy(state)
	if new_name: next_state[new_name] = action[name]
	else: next_state[name] = action[name]
	return next_state

# Metronome reducers

func metronome(state: Dictionary, action: Dictionary) -> Dictionary:
	if type("INPUT_ERROR", action): return new_state("status", action, state)
	
	return state


## Demo functions

func game(state: Dictionary, action: Dictionary) -> Dictionary:
	if type("GAME_SET_START_TIME", action): return new_state("time", action, state, "start_time")

	return state

func player(state: Dictionary, action: Dictionary) -> Dictionary:
	if type("PLAYER_SET_NAME", action): return new_state("name", action, state)
	if type("PLAYER_SET_HEALTH", action): return new_state("health", action, state)

	return state
