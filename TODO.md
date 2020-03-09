# TODO

## 0.1

- test MDM with basic music layers
- check if metronome can be useful, import if from previous project (onna) and sync it to MDM / check synchronisation of metronome tick and MDM tick
- add audio bulk upload to MDM :
  - open multiple ogg/wav files
  - import setting : loop off
  - add an audioplayer stream and name them with name file
  - add them to coreContainer or other type
- do we need more music data from signals ?
- ask arlez about MIDI parsing feature (again...) ?
- do basic mechanic tests and define the scope of the tools needed
- ask community about how to make daw plugin

## Bugs & features

- autoplay has to be assigned to MDM node
- endless loop ends after 2 plays when only one song in MDM, solved with 2 songs
- have the option to reset beat number at each bar
- have the option to export absolute time (for later sync with events and MIDI)
- on mdm.stop(song), error : _disconnect: Nonexistent signal 'finished' in [AudioStreamPlayer:1195]
- on song changed signal, error : emit_signal: Error calling method from signal 'song_changed': Method expected 2 arguments, but called with 1..
- how to access vars like current_song, is_playing, etc. ?
- strange accumulation of bars when 2 songs played, not 1 > 2 then 3 > 4 or 1 > 2 for second song, but 2 > 3

## Tool features

- export cubase marker track in midi file and lay out audio files and midi data according to markers
- how to export audio files chunks from Cubase ? Need to check XML export format and music notation maybe
- each audio / midi data will have its local and global time
- bulk load audio files and name / import them in scene audioPlayers
- check how to manage layering, fades, rollovers, pre-enter
- sync audio files and midi tracks through name comparison
- arrange tracks in structure given by marker track
- sync time and bpm data
- each track can be setup to wait for a signal event to play and stop
- midi data can be selected in GUI and used to send time data like start_time, end_time, event_duration, note_height, event_velocity
- midi data can be used to drive bus effects (EQ, filters, Reverb, etc.) and have procedural ambiances according to levels (ex: enter hammam, error in input makes sound 'as in a womb')
- midi data can be used to drive animation (animation duration, easings, keyframe insertion, keyframe value, etc.)
- objects in game inherit a musical class that gives properties like accessing tempo and midi data, auto-injected animationPlayer, specific signals, custom DAW panel on editor clic, etc.