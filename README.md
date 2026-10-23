# ATA-1 — 3D Open-World Game

A Windows PC 3D game project built with Godot 4.

## Current prototype

- Three selectable protagonists: Alex, Maya and Ravi
- Switch characters with keys 1, 2 and 3
- Third-person follow cameras and mouse look
- WASD / arrow keys to move, Shift to sprint, Space to jump
- HUD with active character, placeholder health/stamina and money display
- In-game smartphone shared by all characters: press **P** to open/close
- Phone apps: Contacts, Messages, Map, Camera and Settings (currently UI placeholders)
- Six stylized Indian road vehicles: hatchback, sedan, SUV, yellow-green auto-rickshaw, taxi and delivery van
- Moving traffic prototype with six cars looping along two generated road lanes
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

The protagonists, vehicles, airport and train currently use generated placeholder meshes, not finished realistic 3D assets. The six parked vehicles are decorative and are not drivable. Traffic cars move in a simple loop; they do not yet have traffic lights, collision avoidance, lane changes or police behavior. The airport and railway station are visual landmarks only: aircraft and train do not travel, and tickets, boarding, destinations and timetables are not implemented. Health, stamina and money are visual placeholders. Phone apps are interface prototypes: calling, real messaging, GPS mapping and camera capture are not connected yet.

This project has not yet been validated by running it in the Godot editor. Please test it in Godot and report any errors before building more features.
