# Musilogy (closed)
Creating a tool for musical logic in Godot game engine

**Closed project : found an API in Unity better suited for this project.**

## Versions

- 0.4 (30/03/2020 > 04/04/2020):
  - UI & UDF architecture implementation
- 0.3 (20/03/2020 > 30/03/2020):
  - applying functional paradigm to metronome algorithm by subdividing time data + refactoring metronome for API
- 0.2 (11/03/2020 > 18/03/2020): 
  - made a working but lacking metronome (heavy data structure, counting bugs, physics based, confusing state machine base)
- 0.1 (06/03/2020 > 10/03/2020):
  - tried MDM and understood the need for a custom tool that goes deeper into linking music data and game logic

## Audio

- Metronome with time signature
- Musical GUI to sync audio data with game logic

## Graphic

- Blender and/or SVG mesh import
- Working curved platforms (normals, collisions, occlusion, gravity, movement, rotation)

## Architecture

- Functional paradigm & Unidirectional Data Flow (UDF) through Central Data Structure (CDS) and signals
- Link music data (tempo, audio sections, MIDI events) and game elements (signals, animations, properties)