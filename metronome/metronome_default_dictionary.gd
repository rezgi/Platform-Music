extends Node

const Metronome := {
	subdivisions = {
		hundredtwentyeight = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 2,
			},
		sixtyfourth = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 4,
			sound = {
				on = false,
				pitch = 12,
				volume = -12
				}
			},
		thirtysecond = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 4,
			sound = {
				on = false,
				pitch = 10,
				volume = -10
				}
			},
		sixteenth = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 4,
			sound = {
				on = false,
				pitch = 8,
				volume = -8
				}
			},
		eight = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 4,
			sound = {
				on = false,
				pitch = 6,
				volume = -6
				}
			},
		quart = {
			duration = 0.0,
			tempo_count = 1,
#			threshold = 0,
			sound = {
				on = false,
				pitch = 4,
				volume = -4
				}
			},
		half = {
			duration = 0.0,
			tempo_count = 1,
			sound = {
				on = false,
				pitch = 2,
				volume = -2
				}
			},
		full = {
			duration = 0.0,
			tempo_count = 1,
			sound = {
				on = false,
				pitch = 1,
				volume = 0
				}
			}
	},
	info = {
		bpm = 0,
		beats_per_bar = 0,
		beat_length = "",
		delay = 0.0,
#		delta = 0.0,
		delta_accumulator = 0.0,
		secondary_counter = 1,
		secondary_index = 0,
		smallest_subdivision = 0,
		metronome_is_on = false
	}
}

static func get_default_metronome_dictionary() -> Dictionary:
	return Metronome
