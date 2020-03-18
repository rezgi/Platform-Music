# Musilogy
Creating a tool for musical logic in Godot game engine

[TODO](TODO.md)

## Versions

- 0.3 (19/03/2020 > ?):
  - applying functional paradigm and UDF
- 0.2 (11/03/2020 > 18/03/2020): 
  - made a working but lacking metronome (heavy data structure, counting bugs, physics based, confusing state machine base)
- 0.1 (06/03/2020 > 10/03/2020):
  - tried MDM and understood the need for a custom tool that goes deeper into linking music data and game logic

---

## Audio

- Metronome with time signature
- Musical GUI to sync audio data with game logic

## Graphic

- Blender and/or SVG mesh import
- Working curved platforms (normals, collisions, occlusion, gravity, movement, rotation)

## Architecture

- Functional paradigm & Unidirectional Data Flow (UDF) through Central Data Structure (CDS) and signals
- Link music data (tempo, audio sections, MIDI events) and game elements (signals, animations, properties)