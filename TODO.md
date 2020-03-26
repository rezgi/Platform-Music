# TODO

## 0.4
UI, CDS & UDF implementation

- [ ] insted of input_check() : lock input fields for no error possibility (BPM only ranged int, signature : ranged int / menu list)
- [ ] export variables in the node settings for metronome debug
- [ ] make togglable UI tool to play metronome in any scene
- [ ] make the metronome (and time_start init) on UI trigger
- [ ] convert metronome sounds to .wav
- [ ] experiment wav exports with 0db zones and compare file sizes
- [ ] experiment compression of wav files (and decompression in godot) and compare file size
- [ ] implement Unidirectional DataFlow (UDF) inspired by godot Redux and experiment
- [ ] refactor data structure (named Central Data Structure : CDS)
- [ ] have one signal fired for any UI elements change, send UI element data (button, inputs)
- [ ] try scanning all inputs and auto-connecting them ?

## 0.3
Switch from state machine to functional paradigm

- [ ] need a bool to activate counter in process, probably a start() and stop() function
- [x] tempo_to_time
- [x] bug with image that godot doesn't find -> bug when root node is Node, solved by using Control node instead
- [x] think about how to separate dotted ? maybe not needed
- [x] is join_tempo needed ? removed it for the moment
- [x] maybe delay (remainder of tempo divisions) should be taken into account
- [x] tempo data structure still not clear : 1 array of all subdivisions ? 2 arrays for primary & secondary ?
- [x] dotted_time
- [x] divisions work well. implement secondary tempo
- [x] decide on how far subdivisions should go and how to implement it
- [x] time_to_tempo still works incrementally (and buggy), try to divide time and compute remainders
- [x] used OS.get_system_time_msecs() insted of ticks, better approach, no float comparison, just remainder
- [x] comparing floats is tricky, used epsilon method, have doubts about the smallest comparison
- [x] because ticks are small, sometimes comparison is true multiple times
- [x] ticks counting doesn't start at 0, used in ready for the moment, see if problem
- [x] start OS.time at start of metronome, then compare time passed and convert to tempo
- [x] use already made signature conversion functions
- [x] separate from the start : metronome logic / UI / data / tools
- [x] set engine to 60FPS
- [x] make only pure functions and pass the data tree
- [x] should tempo data be an array ? maybe simpler to pass around, dict can be returned in a function

---

## Roadmap

- 0.3 :
  - full metronome that converts time and tempo in a single data structure and adapts to FPS
- 0.4 :
  - unilateral dataflow (UDF) experimenting and connect metronome
  - input auto-connector : scan scene, select UI inputs and connect chosen signals, gather signals into one that's connected to UDF
- 0.5 : 
  - tempo grid :
  - reads & displays tempo UDF
  - time cursor
  - bpm subdivisions
  - play, pause, stop
  - total time duration
  - zoom in & out
  - one audio layer test
- 0.6 : 
  - audio project creator / importer
  - bulk audio import : auto-creation, naming and injection of audio nodes
  - read and parse midi JSON that will set the grid layers, duration & markers
  - create midi tracks and display notes
  - audio tracks will be compared to midi track names, name them accordingly and sync them on the same layers
  - analyse audio spectrums and overlay them with midi notes, 0db sections won't be displayed, audio sections will be automatically created for loops
  - SFX & overlays can be imported and have their own container type, not depending on sections but events
- grid layers :
  - sections : 
    - music section
    - can be looped
    - have general time according to total time and relative time for its own local time (starts at 0)
    - has its own layers
  - markers :
    - can be edited (add, remove, rename, move) ?
    - imported from midi markers
    - multiple marker layers ?
    - used for logic
  - audio :
    - bulk import of audio files
    - import full length audio from cubase
    - spectrum analysis & display
    - remove 0db sections
    - played only in given sections
    - marker logic
    - bus assign
    - procedural fades, punch-in, etc.
  - midi : 
    - import from midi JSON
    - check midi_player by arlez for integration (parse to dict, play)
    - generate sections from markers
    - notes display (in bars or computed curves) with exportable values, in time, out time, durations
    - track automations
    - overlay with audio waveform
    - selectable for logic menu
  - events : 
    - created by clicks on GUI
    - can be on marker / section / audio / midi start / end
    - generate signals / animation keys / easing curves / play loops
    - animationPlayer keyframes overlay on midi / audio visuals
    - test import from blender dopeSheet
  - inputs : 
    - define where and how player inputs interact (tap, hold, direction, swipe)
    - emit signals and call methods
- level sections are assigned to music sections
  - from level are inherited level elements that are assigned to midi/audio events
  - level elements have their own focused music layers for editing animation and interaction
  - can read updated conditions from outside main data (ex: is door open)
  - level is a scene, elements have their own scene with their inherited music layers
- use cases :
  - clicking on a song section to generate a level section
  - clicking on an midi / audio track in section to generate a level element scene
  - tracks and sections can be routed to buses, signals, animationPlayers, nodeTree
- misc :
  - nodal UI to manage interactions, data communication, signal & events

---

## 0.2
Working metronome with state machine paradigm

- [x] get a clean tempo data structure with subdivisions in bpm and time (1/16 may be enough, see if 1/32 or 1/64 is doable in another way)
- [x] cleaner algorithm, better time signature consideration and data structure
- [x] refactor counting algorithm with new data structure, test OS.get_ticks_msec() again, maybe finer counting and less delay
- [x] delta is too big in 60FPS, either limit the subdivisions to 1/16 or augment the FPS to 120 (even though there are still precision issues)
- [x] solve 1/32, 1/8, 1/2 measure counting issue
- [x] test for weird measures like 3/8 for ex
- [x] small delay of nearly 0.002s, used it by adding it to delta_accumulator, made faster BPM work
- [x] have 2 tempo displays : [1, 1/4, 1/16, 1/64] & [1/2, 1/8, 1/32, 1/128]
- [x] refactor Metronome dictionary : m.subdivisions {subdivision_type{duration,tempo_count,threshold}} / m.info
- [x] make metronome adapt to FPS & BPM : if 1/128 < delta, test 1/64, if still smaller, use 1/16 counting
- [x] update counting code with new data structure and looping function
- [x] create sound settings dict {is_on, pitch, volume} in each subdivision dict
- [x] update button signal functions to change bool within metronome dict
- [x] check if half note works with 3/4
- [ ] half shifts every 3 measures when using odd bars
- [ ] 32 bugs on high BPM
- [ ] 64th sound not working
- [ ] adapt reset function to new data structure
- [ ] data check in button function, adapt to generic start() method
- [ ] set() doesn't check for input integrity, will be easier to adapt without button logic, make return bool
- [ ] make a generic time_input getter that returns dictionary (bpm, beats_per_bar, beat_length)
- [ ] additional methods : tempo to time, time to tempo
- [ ] implement dotted time, add secondary tempo to primary : prim[1] + sec[1] : 1/4 + 1/8
- [ ] put a set() to update metronome while it's running, for when changing signatures or BPM when counting
- [x] rename scene to 'Metronome' and give class_name & icon
- [x] delete old tempo.tscn & its script
- [x] delete audio files, don't need for the time being
- [ ] one field for time signature ?
- [ ] make field text all selected when click on it
- [ ] separate UI and metronome logic
- [ ] Metronome dict put into external script. Still understanding how instanciating works to be able to reset the dict
- [ ] modulate script : signals / UI inputs / tempo. leave only main logic and exposed methods in here
- [ ] Metronome dict is accessed globaly, pass it to funcs using it, think about how data will be used outside with redux design
- [ ] gather all buttons & text input signals and combine them into one signal, procedural
- [ ] a functional way to treat signals : central data that changes when a signal comes, loop to read from it
- [ ] design the API to use its methods : start(), stop(), reset(), get()->dict, set()->dict, tempo_to_time()->float?, time_to_tempo()->array, dotted()->?
- [ ] signal on each tick, send measure dict
- [ ] check if functional paradigm applied
- [ ] make UI togglable for integration into other scenes, or integrate into Inspector ? Both ?
- [ ] display running time sync with tempo updates (1/64)
- [ ] test for signatures changes while running, use yield to wait for next measure

## 0.1
MDM Experiment

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
