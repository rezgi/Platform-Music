extends Node

var Metronome := {
	subdivisions = {
		full = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 1,
				volume = 0
				}
			},
		half = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 2,
				volume = -2
				}
			},
		quart = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 4,
				volume = -4
				}
			},
		eight = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 6,
				volume = -6
				}
			},
		sixteenth = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 8,
				volume = -8
				}
			},
		thirtysecond = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 10,
				volume = -10
				}
			},
		sixtyfourth = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 12,
				volume = -12
				}
		},
		hundredtwentyeight = {
			duration = 0.0,
			count = 1,
			sound = {
				on = false,
				pitch = 14,
				volume = -14
				}
			}
	},
	info = {
		bpm = 0,
		beats_per_bar = 0,
		beat_length = "",
		delay = 0.0,
		delta_accumulator = 0.0,
		smallest_subdivision = 0,
		metronome_is_on = false,
		time_start = 0.0,
		time_now = 0.0
	}
}

static func get_default_data() -> Dictionary:
	return Metronome
