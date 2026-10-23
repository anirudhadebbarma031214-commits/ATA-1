# ATA-1 — 3D Open-World Game

A Windows PC 3D game project built with Godot 4.

## Current prototype

- Three selectable protagonists: Alex, Maya and Ravi
- On-screen character switching panel with clickable Alex, Maya and Ravi buttons, active-character highlight and keyboard shortcuts 1, 2 and 3
- Switch characters with keys 1, 2 and 3
- Third-person follow cameras and mouse look
- WASD / arrow keys to move, Shift to sprint, Space to jump
- HUD with active character, placeholder health/stamina and money display
- In-game smartphone shared by all characters: press **P** to open/close
- Phone apps: Contacts, Messages, Map, Camera and Settings (currently UI placeholders)
- Six stylized Indian road vehicles: hatchback, sedan, SUV, yellow-green auto-rickshaw, taxi and delivery van
- Moving traffic prototype with six cars looping along two generated road lanes
- Enter and drive parked Indian vehicle prototypes: approach and press E; W/Up accelerates, S/Down reverses/brakes, A/D or left/right steers, Space brakes, E exits
- Simple red/green signal lights that change every eight seconds
- Animated placeholder aircraft and train components move across their respective display areas
- Original 78-mission campaign across 10 chapters, with a glowing world objective marker and mission log (press J)
- Reach the current mission marker and press F to complete it and unlock the next objective
- Stylized Agartala airport landmark with terminal, runway markings and a parked placeholder aircraft
- Stylized Agartala railway station landmark with platforms, rails, a stationary train engine and coaches
- Lightweight Godot Compatibility renderer

## Open the project

1. Install Godot 4.3 or newer from https://godotengine.org/download/windows/.
2. Download this repository using **Code → Download ZIP**, then extract it.
3. Open Godot and choose **Import**.
4. Select the extracted folder containing `project.godot`.
5. Press **F5** to run the project.

## Important limitations

The protagonists, vehicles, airport and train currently use generated placeholder meshes, not finished realistic 3D assets. The parked vehicles can be entered and driven using a simple prototype controller; they do not yet have vehicle physics, wheel suspension, damage or collision avoidance. Traffic cars move in a simple loop and signal lights change color, but traffic does not stop at signals and has no lane changes or police behavior. The airport aircraft and railway train are simple animated placeholder meshes, not full flight/train simulations. Tickets, boarding, destinations, schedules, airport/railway interiors and passenger systems are not implemented. Health, stamina and money are visual placeholders. Phone apps are interface prototypes: calling, real messaging, GPS mapping and camera capture are not connected yet.

The 78-mission campaign currently uses a prototype objective loop: travel to each glowing marker and press F nearby. Mission names and chapters are original, but detailed dialogue, voice acting, bespoke cutscenes, NPC-specific interactions, mission rewards, save/load and cinematic scripting still need to be developed. This project has not yet been validated by running it in the Godot editor. Please test it in Godot and report any errors before building more features.
