# TODO

## 0.2

- [x] get a clean tempo data structure with subdivisions in bpm and time (1/16 may be enough, see if 1/32 or 1/64 is doable in another way)
- [x] cleaner algorithm, better time signature consideration and data structure
- [x] refactor counting algorithm with new data structure, test OS.get_ticks_msec() again, maybe finer counting and less delay
- [x] delta is too big in 60FPS, either limit the subdivisions to 1/16 or augment the FPS to 120 (even though there are still precision issues)
- [x] solve 1/32, 1/8, 1/2 measure counting issue
- [x] test for weird measures like 3/8 for ex
- [x] small delay of nearly 0.002s, used it by adding it to delta_accumulator, made faster BPM work
- [x] have 2 tempo displays : [1, 1/4, 1/16, 1/64] & [1/2, 1/8, 1/32, 1/128]

### Tempo algorithm

- [ ] Make metronome adapt to FPS & BPM : if 1/128 < delta, test 1/64, if still smaller, use 1/16 counting
- [ ] Make better counting code since lots of repetitions and conditions with regular parameters
- [ ] additional methods : tempo to time, time to tempo
- [ ] implement dotted time, add secondary tempo to primary : prim[1] + sec[1] : 1/4 + 1/8
- [ ] check if half note works with 3/4
- [ ] put a set() to update metronome while it's running, for when changing signatures or BPM when counting

### UI

- [ ] one field for time signature ?
- [ ] make field text all selected when click on it
- [x] rename scene to 'Metronome' and give class_name & icon
- [x] delete old tempo.tscn & its script

### Code design

- [ ] Metronome dict is accessed globaly, pass it to funcs using it maybe
- [ ] modulate script : signals / UI inputs / tempo. leave only main logic and exposed methods in here
- [ ] gather all buttons & text input signals and combine them into one signal, procedural
- [ ] a functional way to treat signals : central data that changes when a signal comes, loop to read from it

### Use outside the scene

- [ ] design the API to use its methods : start(), stop(), reset(), get()->dict, set()->dict, tempo_to_time()->float?, time_to_tempo()->array, dotted()->?
- [ ] signal on each tick, send measure dict
- [ ] check if functional paradigm applied
- [ ] make UI togglable for integration into other scenes, or integrate into Inspector ? Both ?
- [ ] display running time sync with tempo updates (1/64)
- [ ] test for signatures changes while running, use yield to wait for next measure

## Steps

- design a tempo grid that will sync and display tempo data : time cursor, bpm subdivisions, play, pause, stop, total time duration, zoom in & out
- create an audio project creator/importer
  - read and parse midi JSON that will set the grid layers, duration & markers
  - create midi tracks and display notes
  - bulk import of audio tracks that will compare with midi tracks, name them accordingly, sync them on the same layers and create audioStreams
  - analyse audio spectrums and overlay them with midi notes, 0db sections won't be displayed, audio sections will be automatically created for loops
  - SFX & overlays can be imported and have their own container type, not depending on sections but events
- add layers to the grid : sections, markers, audio, midi, events
  - sections : music section, can be looped, have general time according to total time and relative time for its own local time (starts at 0), has its own layers
  - markers : can be edited (add, remove, rename, move), imported from midi markers, can have multiple marker layers, used for logic
  - audio : import full length audio from cubase, spectrum analysis & display, remove 0db sections, played only in given sections, marker logic, bus assign
  - midi : import from midi JSON, can generate sections from markers, notes display (bars & curves), track automations, overlay with audio, selectable and logic menu
  - events : from clicks on GUI, can be on marker/section/audio/midi start/end, generate signals/animation keys/easing curves/play loops
  - inputs : define where and how player inputs interact (tap, hold, direction, swipe)
  - animationPlayer keyframes overlay on midi/audio visuals, test import from blender dopeSheet, emit signals and call methods
- level sections are assigned to music sections
  - from level are inherited level elements that are assigned to midi/audio events
  - level elements have their own focused music layers for editing animation and interaction
  - can read updated conditions from outside main data (ex: is door open)
  - level is a scene, elements have their own scene with their inherited music layers
- ex: clicking on a song section to generate a level section / clicking on an midi/audio track in section to generate a level element scene
- tracks and sections can be routed to buses, signals, animationPlayers, nodeTree
- nodal UI to manage interactions, data communication, signal & events
- custom musical logic editor name tentatives : Musilogy, goDAW, godAudio, audioLogic

## 0.1

- test MDM with basic music layers
- check if metronome can be useful, import if from previous project (onna) and sync it to MDM / check synchronisation of metronome tick and MDM tick
- add audio bulk upload to MDM :
  - open multiple ogg/wav files
  - import setting : loop off
  - add an audioplayer stream and name them with name file
  - add them to coreContainer or other type
- bugs :
  - autoplay has to be assigned to MDM node
  - endless loop ends after 2 plays when only one song in MDM, solved with 2 songs
  - have the option to reset beat number at each bar
  - have the option to export absolute time (for later sync with events and MIDI)
  - on mdm.stop(song), error : _disconnect: Nonexistent signal 'finished' in [AudioStreamPlayer:1195]
  - on song changed signal, error : emit_signal: Error calling method from signal 'song_changed': Method expected 2 arguments, but called with 1..
  - how to access vars like current_song, is_playing, etc. ?
  - strange accumulation of bars when 2 songs played, not 1 > 2 then 3 > 4 or 1 > 2 for second song, but 2 > 3

- decision : not use MDM, game mechanics need way more refined musical data imported from DAW. Custom tool to make
- Tempo tool import from Onna project
- Refactoring aiming for use in DAW tool :
  - more measure subdivision : add up to 1/16th note length
  - better tempo naming : section, whole (1), half (1/2), half_dot (1/2.), quarter (1/4), quarter_dot (1/4.), eight (1/8), eight_dot (1/8.), sixteenth (1/16), sixteenth_dot (1/16.)
  - check latency, use delta instead of timer ? no, try OS.get_ticks_msec() until it reaches the given bpm2time. No, get back to timer

## Tool features & ideas

- export cubase marker track in midi file and lay out audio files and midi data according to markers
- how to export audio files chunks from Cubase ? Need to check XML export format and music notation maybe / will export full length audio and cut in game
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
