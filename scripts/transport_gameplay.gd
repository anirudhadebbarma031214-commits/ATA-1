extends Node3D
## Prototype vehicle driving, traffic signals and transport interactions.
## Walk close to a parked vehicle and press E to enter/exit. While driving:
## W/Up accelerates, S/Down brakes/reverses, A/D steer, Space brakes.
var player: CharacterBody3D
var active_vehicle: Node3D
var driving := false
var drive_speed := 0.0
var steering := 0.0
var traffic_lights: Array[Dictionary] = []
var flight_plane: Node3D
var train: Node3D
var signal_timer := 0.0
var signal_green := true
var notice_label: Label
var notice_timer := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("playable_characters") as CharacterBody3D
	_add_notice_ui()
	_add_traffic_signals()
	_add_transport_motion()

func _process(delta: float) -> void:
	if notice_timer > 0:
		notice_timer -= delta
		if notice_label:
			notice_label.visible = notice_timer > 0
	signal_timer += delta
	if signal_timer >= 8.0:
		signal_timer = 0.0
		signal_green = not signal_green
		_update_signal_lights()
	if driving:
		_drive_update(delta)
	if flight_plane:
		flight_plane.position.x += delta * 3.0
		if flight_plane.position.x > 17.0:
			flight_plane.position.x = -17.0
	if train:
		train.position.x += delta * 1.6
		if train.position.x > 15.0:
			train.position.x = -15.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		if driving:
			_exit_vehicle()
		else:
			_try_enter_vehicle()

func _try_enter_vehicle() -> void:
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("playable_characters") as CharacterBody3D
	if not player:
		_show_notice("Player not found")
		return
	var closest: Node3D
	var closest_distance := 4.5
	for vehicle in get_tree().get_nodes_in_group("drivable_vehicles"):
		if vehicle is Node3D:
			var distance := player.global_position.distance_to(vehicle.global_position)
			if distance < closest_distance:
				closest = vehicle
				closest_distance = distance
	if closest:
		active_vehicle = closest
		driving = true
		drive_speed = 0.0
		player.visible = false
		player.set_physics_process(false)
		_show_notice("Driving: W accelerate • S brake • A/D steer • E exit")
	else:
		_show_notice("Move close to a parked car and press E")

func _exit_vehicle() -> void:
	if not player or not active_vehicle:
		driving = false
		return
	driving = false
	player.visible = true
	player.set_physics_process(true)
	player.global_position = active_vehicle.global_position + active_vehicle.global_basis.x * 2.8 + Vector3.UP
	player.velocity = Vector3.ZERO
	drive_speed = 0.0
	active_vehicle = null
	_show_notice("Exited vehicle")

func _drive_update(delta: float) -> void:
	if not active_vehicle or not player:
		driving = false
		return
	var forward_input := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		forward_input = 1.0
	elif Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		forward_input = -1.0
	var steer_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		steer_input = -1.0
	elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		steer_input = 1.0
	if Input.is_key_pressed(KEY_SPACE):
		drive_speed = move_toward(drive_speed, 0.0, 24.0 * delta)
	else:
		drive_speed += forward_input * 12.0 * delta
		drive_speed = clampf(drive_speed, -7.0, 24.0)
	active_vehicle.rotate_y(-steer_input * delta * clampf(absf(drive_speed) / 8.0, 0.0, 1.8))
	active_vehicle.global_position += -active_vehicle.global_basis.z * drive_speed * delta
	player.global_position = active_vehicle.global_position + Vector3.UP * 1.0
	player.global_rotation.y = active_vehicle.global_rotation.y

func _add_notice_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "TransportNoticeLayer"
	add_child(layer)
	notice_label = Label.new()
	notice_label.position = Vector2(24, 90)
	notice_label.add_theme_font_size_override("font_size", 18)
	notice_label.add_theme_color_override("font_color", Color(1, 1, 1))
	notice_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	notice_label.add_theme_constant_override("shadow_offset_x", 2)
	notice_label.add_theme_constant_override("shadow_offset_y", 2)
	notice_label.visible = false
	layer.add_child(notice_label)

func _show_notice(message: String) -> void:
	if notice_label:
		notice_label.text = message
		notice_label.visible = true
		notice_timer = 4.0

func _add_traffic_signals() -> void:
	for road_z in [-15.0, 15.0]:
		var pole := MeshInstance3D.new()
		var pole_mesh := CylinderMesh.new()
		pole_mesh.top_radius = 0.12
		pole_mesh.bottom_radius = 0.12
		pole_mesh.height = 4.0
		pole.mesh = pole_mesh
		pole.position = Vector3(0, 2, road_z + 5.0)
		pole.material_override = _mat(Color(0.18, 0.18, 0.2))
		add_child(pole)
		var lamp := MeshInstance3D.new()
		var lamp_mesh := SphereMesh.new()
		lamp_mesh.radius = 0.48
		lamp_mesh.height = 0.96
		lamp.mesh = lamp_mesh
		lamp.position = Vector3(0, 4.2, road_z + 5.0)
		lamp.material_override = _mat(Color(0.05, 0.85, 0.2) if signal_green else Color(0.9, 0.05, 0.03))
		add_child(lamp)
		traffic_lights.append({"lamp": lamp})

func _update_signal_lights() -> void:
	for item in traffic_lights:
		var lamp: MeshInstance3D = item["lamp"]
		lamp.material_override = _mat(Color(0.05, 0.85, 0.2) if signal_green else Color(0.9, 0.05, 0.03))

func _add_transport_motion() -> void:
	var hubs := get_node_or_null("../TransportHubs")
	if not hubs:
		return
	var airport := hubs.get_node_or_null("AgartalaAirport")
	if airport:
		flight_plane = airport.get_node_or_null("ParkedAircraftBody")
	var station := hubs.get_node_or_null("AgartalaRailwayStation")
	if station:
		train = station.get_node_or_null("TrainEngine")

func _mat(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	emission_color_set(material, color)
	return material

func emission_color_set(material: StandardMaterial3D, color: Color) -> void:
	material.emission_enabled = true
	material.emission = color
