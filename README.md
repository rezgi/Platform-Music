# Platform-Music
Experiments with procedural music and platform mechanics in Godot game engine

## Experiments

- Music layering and interaction with Godot Mixing Desk
- MIDI (external JSON converter, maybe extend godot-midi-player) parsing, display, logic and editor interface
- Blender to Godot import workflow with godot-game-tools / collada-exporter / godot-blender-exporter
- Procedural meshes, 2D SVG shapes and 3D basic objects
- Circular levels with physics and collisions
- Creation of plugin interfaces within the editor

## Goals

### For the brain :
- Procedural music logic ready for game mechanics
- Usable and visible MIDI data structures
- Good understanding of the 3D import workflow from Blender to Godot
- Working circular platform levels and elements

### For the game :
- Overall music logic architecture usable for game mechanics
- Usable interface in editor to link musical events and game mechanics
- Working imported assets and circular design
- Design a tool that encompasses all experimented tools into a musical game creator
- Basic musical platform gameplay

## Tool

- Music data creation : 
-- bulk audio files import to structure in editor
-- MIDI file conversion and parsing to data structure
- Music data structure :
-- audio layers ready to use
-- tempo data synced with temporal data
-- MIDI events synced with audio layers and tempo
-- events and logic structured for game mechanics
- Asset import :
-- defined import workflow from Blender to Godot
-- mesh generation from imported assets
-- generate shapes, normals, collisions, physics and occlusion
- Music logic interface :
-- editor plugin to display music and MIDI data synced with time
-- game clock, logic and events in sync with music tempo
-- logic editor for scenario, scenes, level, objects and player
- Platform logic
-- adapted physics and interactions to music and circular design
-- animations synced with music
-- level structure synced to music structure and logic

Overall, have a full music visual game editor that :
- imports music data (audio & midi) and assets (3D and 2D objects)
- generates data in the engine through music events (DAW-like with clickable and editable elements) and visible meshes
- links them together in the game logic through events and level building
- allows natural game and level design in the editor

![Good Luck !](https://media.giphy.com/media/Y2b0W3I2UnNiVuYhVc/giphy.gif "Good Luck !!")
