extends Node3D
## Original 78-mission open-world campaign prototype for ATA-1.
## J toggles mission log. Reach the glowing marker and press F to complete a mission.
const MISSIONS: Array[Dictionary] = [
	{"id": 1, "chapter": 1, "title": "First Day in Agartala", "description": "Travel to the marked city location and check in.", "target": Vector3(0, 0, 0)},
	{"id": 2, "chapter": 1, "title": "Find Your Feet", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-12, 0, -5)},
	{"id": 3, "chapter": 1, "title": "A Call from Home", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(12, 0, -5)},
	{"id": 4, "chapter": 1, "title": "The Old Neighbour", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-16, 0, 4)},
	{"id": 5, "chapter": 1, "title": "Market Run", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(16, 0, 4)},
	{"id": 6, "chapter": 1, "title": "A Small Favour", "description": "Travel to the marked city location and check in.", "target": Vector3(-12, 0, 8)},
	{"id": 7, "chapter": 1, "title": "Missing Parcel", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(12, 0, 8)},
	{"id": 8, "chapter": 1, "title": "The Long Way Home", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-31, 0, -31)},
	{"id": 9, "chapter": 2, "title": "Badarghat Morning", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(31, 0, 31)},
	{"id": 10, "chapter": 2, "title": "Auto Stand Stories", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(0, 0, -15)},
	{"id": 11, "chapter": 2, "title": "The Late Delivery", "description": "Travel to the marked city location and check in.", "target": Vector3(0, 0, 15)},
	{"id": 12, "chapter": 2, "title": "Traffic Trouble", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-20, 0, 20)},
	{"id": 13, "chapter": 2, "title": "A Friend in Need", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(20, 0, -20)},
	{"id": 14, "chapter": 2, "title": "Tea Stall Meeting", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(0, 0, 0)},
	{"id": 15, "chapter": 2, "title": "The Wrong Turn", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(-12, 0, -5)},
	{"id": 16, "chapter": 2, "title": "Market Rush", "description": "Travel to the marked city location and check in.", "target": Vector3(12, 0, -5)},
	{"id": 17, "chapter": 3, "title": "Mom's Shopping List", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-16, 0, 4)},
	{"id": 18, "chapter": 3, "title": "Dad's Errand", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(16, 0, 4)},
	{"id": 19, "chapter": 3, "title": "Family Photograph", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-12, 0, 8)},
	{"id": 20, "chapter": 3, "title": "A Surprise Visit", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(12, 0, 8)},
	{"id": 21, "chapter": 3, "title": "Dinner Is Ready", "description": "Travel to the marked city location and check in.", "target": Vector3(-31, 0, -31)},
	{"id": 22, "chapter": 3, "title": "The Forgotten Key", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(31, 0, 31)},
	{"id": 23, "chapter": 3, "title": "Neighbourhood Help", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(0, 0, -15)},
	{"id": 24, "chapter": 3, "title": "A Promise Made", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(0, 0, 15)},
	{"id": 25, "chapter": 4, "title": "First Drive", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(-20, 0, 20)},
	{"id": 26, "chapter": 4, "title": "Fuel and Go", "description": "Travel to the marked city location and check in.", "target": Vector3(20, 0, -20)},
	{"id": 27, "chapter": 4, "title": "Beat the Clock", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(0, 0, 0)},
	{"id": 28, "chapter": 4, "title": "The Roadblock", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-12, 0, -5)},
	{"id": 29, "chapter": 4, "title": "Signal Trouble", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(12, 0, -5)},
	{"id": 30, "chapter": 4, "title": "Taxi for Two", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(-16, 0, 4)},
	{"id": 31, "chapter": 4, "title": "The Repair Shop", "description": "Travel to the marked city location and check in.", "target": Vector3(16, 0, 4)},
	{"id": 32, "chapter": 4, "title": "Night Drive", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-12, 0, 8)},
	{"id": 33, "chapter": 5, "title": "Station Pickup", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(12, 0, 8)},
	{"id": 34, "chapter": 5, "title": "Platform Number Two", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-31, 0, -31)},
	{"id": 35, "chapter": 5, "title": "The Lost Bag", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(31, 0, 31)},
	{"id": 36, "chapter": 5, "title": "A Train to Catch", "description": "Travel to the marked city location and check in.", "target": Vector3(0, 0, -15)},
	{"id": 37, "chapter": 5, "title": "Courier on Rails", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(0, 0, 15)},
	{"id": 38, "chapter": 5, "title": "Meet Me Outside", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-20, 0, 20)},
	{"id": 39, "chapter": 5, "title": "The Last Passenger", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(20, 0, -20)},
	{"id": 40, "chapter": 5, "title": "Station After Dark", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(0, 0, 0)},
	{"id": 41, "chapter": 6, "title": "Airport Run", "description": "Travel to the marked city location and check in.", "target": Vector3(-12, 0, -5)},
	{"id": 42, "chapter": 6, "title": "Ticket Mix-Up", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(12, 0, -5)},
	{"id": 43, "chapter": 6, "title": "The Missing Suitcase", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-16, 0, 4)},
	{"id": 44, "chapter": 6, "title": "Terminal Call", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(16, 0, 4)},
	{"id": 45, "chapter": 6, "title": "Runway Watch", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(-12, 0, 8)},
	{"id": 46, "chapter": 6, "title": "A Visitor Arrives", "description": "Travel to the marked city location and check in.", "target": Vector3(12, 0, 8)},
	{"id": 47, "chapter": 6, "title": "The Return Ride", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-31, 0, -31)},
	{"id": 48, "chapter": 6, "title": "Departure Delay", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(31, 0, 31)},
	{"id": 49, "chapter": 7, "title": "Shopfront Secrets", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(0, 0, -15)},
	{"id": 50, "chapter": 7, "title": "The Honest Mistake", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(0, 0, 15)},
	{"id": 51, "chapter": 7, "title": "A Better Deal", "description": "Travel to the marked city location and check in.", "target": Vector3(-20, 0, 20)},
	{"id": 52, "chapter": 7, "title": "Cash on Delivery", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(20, 0, -20)},
	{"id": 53, "chapter": 7, "title": "The Busy Crossing", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(0, 0, 0)},
	{"id": 54, "chapter": 7, "title": "Help the Vendor", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-12, 0, -5)},
	{"id": 55, "chapter": 7, "title": "A Long Queue", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(12, 0, -5)},
	{"id": 56, "chapter": 7, "title": "The Wrong Address", "description": "Travel to the marked city location and check in.", "target": Vector3(-16, 0, 4)},
	{"id": 57, "chapter": 8, "title": "Old School Friend", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(16, 0, 4)},
	{"id": 58, "chapter": 8, "title": "Teamwork", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-12, 0, 8)},
	{"id": 59, "chapter": 8, "title": "The Photo Challenge", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(12, 0, 8)},
	{"id": 60, "chapter": 8, "title": "A Picnic Plan", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(-31, 0, -31)},
	{"id": 61, "chapter": 8, "title": "Across the City", "description": "Travel to the marked city location and check in.", "target": Vector3(31, 0, 31)},
	{"id": 62, "chapter": 8, "title": "Rainy Day Rescue", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(0, 0, -15)},
	{"id": 63, "chapter": 8, "title": "The Broken Scooter", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(0, 0, 15)},
	{"id": 64, "chapter": 8, "title": "A Thank-You Gift", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-20, 0, 20)},
	{"id": 65, "chapter": 9, "title": "Puja Preparations", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(20, 0, -20)},
	{"id": 66, "chapter": 9, "title": "Lights on the Lane", "description": "Travel to the marked city location and check in.", "target": Vector3(0, 0, 0)},
	{"id": 67, "chapter": 9, "title": "The Dhak Player", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-12, 0, -5)},
	{"id": 68, "chapter": 9, "title": "Flowers for Home", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(12, 0, -5)},
	{"id": 69, "chapter": 9, "title": "Crowd Control", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(-16, 0, 4)},
	{"id": 70, "chapter": 9, "title": "Find the Family", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(16, 0, 4)},
	{"id": 71, "chapter": 9, "title": "A Lost Child", "description": "Travel to the marked city location and check in.", "target": Vector3(-12, 0, 8)},
	{"id": 72, "chapter": 9, "title": "The Evening Aarti", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(12, 0, 8)},
	{"id": 73, "chapter": 10, "title": "The Final Shopping List", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(-31, 0, -31)},
	{"id": 74, "chapter": 10, "title": "A Special Outfit", "description": "Use the streets carefully and arrive at the highlighted location.", "target": Vector3(31, 0, 31)},
	{"id": 75, "chapter": 10, "title": "The Last Delivery", "description": "Take the next step in your Agartala story by reaching the marker.", "target": Vector3(0, 0, -15)},
	{"id": 76, "chapter": 10, "title": "One More Visit", "description": "Travel to the marked city location and check in.", "target": Vector3(0, 0, 15)},
	{"id": 77, "chapter": 10, "title": "The Family Table", "description": "Reach the destination, then press F to complete the objective.", "target": Vector3(-20, 0, 20)},
	{"id": 78, "chapter": 10, "title": "A Walk Through Memories", "description": "Follow the mission marker across the city and help your contact.", "target": Vector3(20, 0, -20)}
]

var current_index := 0
var mission_log_open := false
var marker: MeshInstance3D
var marker_light: OmniLight3D
var title_label: Label
var detail_label: Label
var progress_label: Label
var log_panel: PanelContainer
var log_text: RichTextLabel
var notice_label: Label
var player: Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("playable_characters") as Node3D
	_create_marker()
	_create_ui()
	_refresh_mission()

func _process(delta: float) -> void:
	if marker:
		marker.rotate_y(delta * 0.8)
		marker.position.y = 0.9 + sin(Time.get_ticks_msec() * 0.003) * 0.18
	if marker_light:
		marker_light.light_energy = 1.6 + sin(Time.get_ticks_msec() * 0.004) * 0.4

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.keycode == KEY_J:
		mission_log_open = not mission_log_open
		log_panel.visible = mission_log_open
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if mission_log_open else Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_F and not mission_log_open:
		_try_complete_mission()
		get_viewport().set_input_as_handled()

func _create_marker() -> void:
	marker = MeshInstance3D.new()
	marker.name = "CurrentMissionMarker"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.55
	mesh.bottom_radius = 0.55
	mesh.height = 0.22
	marker.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.05, 0.9, 1.0)
	material.emission_enabled = true
	material.emission = Color(0.05, 0.9, 1.0)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	marker.material_override = material
	add_child(marker)
	marker_light = OmniLight3D.new()
	marker_light.light_color = Color(0.05, 0.85, 1.0)
	marker_light.light_energy = 2.0
	marker_light.omni_range = 8.0
	marker.add_child(marker_light)

func _create_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "MissionCampaignUI"
	add_child(layer)
	var hud := PanelContainer.new()
	hud.position = Vector2(24, 125)
	hud.custom_minimum_size = Vector2(340, 115)
	layer.add_child(hud)
	var stack := VBoxContainer.new()
	hud.add_child(stack)
	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 18)
	stack.add_child(title_label)
	detail_label = Label.new()
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_label.custom_minimum_size = Vector2(315, 45)
	stack.add_child(detail_label)
	progress_label = Label.new()
	stack.add_child(progress_label)
	var help := Label.new()
	help.text = "J MISSION LOG   •   F COMPLETE AT MARKER"
	stack.add_child(help)
	log_panel = PanelContainer.new()
	log_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	log_panel.position = Vector2(-280, -260)
	log_panel.custom_minimum_size = Vector2(560, 520)
	log_panel.visible = false
	log_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	layer.add_child(log_panel)
	var log_stack := VBoxContainer.new()
	log_panel.add_child(log_stack)
	var log_heading := Label.new()
	log_heading.text = "ATA-1  •  STORY CAMPAIGN"
	log_heading.add_theme_font_size_override("font_size", 24)
	log_stack.add_child(log_heading)
	log_text = RichTextLabel.new()
	log_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_text.bbcode_enabled = true
	log_stack.add_child(log_text)
	var close := Button.new()
	close.text = "CLOSE MISSION LOG  [J]"
	close.pressed.connect(func():
		mission_log_open = false
		log_panel.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	)
	log_stack.add_child(close)
	notice_label = Label.new()
	notice_label.position = Vector2(24, 250)
	notice_label.add_theme_font_size_override("font_size", 18)
	layer.add_child(notice_label)

func _refresh_mission() -> void:
	if current_index >= MISSIONS.size():
		title_label.text = "CAMPAIGN COMPLETE"
		detail_label.text = "All 78 missions completed. Thank you for exploring ATA-1."
		progress_label.text = "78 / 78 MISSIONS"
		marker.visible = false
		return
	var mission: Dictionary = MISSIONS[current_index]
	title_label.text = "MISSION %02d  •  %s" % [mission["id"], mission["title"]]
	detail_label.text = str(mission["description"]) + "  (Press F at the marker.)"
	progress_label.text = "CHAPTER %02d  •  %02d / 78" % [mission["chapter"], mission["id"]]
	marker.position = mission["target"]
	marker.visible = true
	_update_log()

func _try_complete_mission() -> void:
	if current_index >= MISSIONS.size():
		return
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("playable_characters") as Node3D
	if not player:
		notice_label.text = "Player not available."
		return
	var distance := player.global_position.distance_to(marker.global_position)
	if distance > 4.5:
		notice_label.text = "Get closer to the glowing mission marker first."
		return
	var finished: Dictionary = MISSIONS[current_index]
	notice_label.text = "MISSION COMPLETE: " + str(finished["title"])
	current_index += 1
	_refresh_mission()

func _update_log() -> void:
	var output := "[b]78 ORIGINAL STORY MISSIONS[/b]\n\n"
	for i in range(MISSIONS.size()):
		var m: Dictionary = MISSIONS[i]
		var prefix := "[color=#49e6a8]✓[/color]" if i < current_index else ("[color=#40dfff]▶[/color]" if i == current_index else "[color=#8994a8]•[/color]")
		output += "%s [b]%02d.[/b] %s  [color=#8994a8](Chapter %d)[/color]\n" % [prefix, m["id"], m["title"], m["chapter"]]
	log_text.text = output
