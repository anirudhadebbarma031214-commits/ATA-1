extends Node3D
## ATA-1 scalable graphics and weather foundation.
## Controls: F6 cycles Clear / Rain / Fog. F7 cycles Balanced / Quality.
## Uses Godot's Compatibility renderer so the project remains friendly to integrated GPUs.

enum Weather { CLEAR, RAIN, FOG }
enum Quality { PERFORMANCE, BALANCED, QUALITY }

@export var follow_active_player := true
@export var rain_particle_count := 700

var weather: Weather = Weather.CLEAR
var quality: Quality = Quality.BALANCED
var world_environment: WorldEnvironment
var environment_resource: Environment
var rain: GPUParticles3D
var sun: DirectionalLight3D
var status_label: Label
var ground_mesh: MeshInstance3D
var ground_material: StandardMaterial3D

func _ready() -> void:
	_build_environment()
	_build_rain()
	_prepare_existing_scene()
	_build_status_label()
	_apply_quality()
	_apply_weather()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_F6:
		weather = (int(weather) + 1) % 3
		_apply_weather()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_F7:
		quality = (int(quality) + 1) % 3
		_apply_quality()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if follow_active_player and is_instance_valid(rain):
		for character in get_tree().get_nodes_in_group("playable_characters"):
			if character.get("is_active") == true:
				rain.global_position = character.global_position + Vector3(0, 17, 0)
				break

func _build_environment() -> void:
	world_environment = WorldEnvironment.new()
	world_environment.name = "ATAWorldEnvironment"
	environment_resource = Environment.new()
	environment_resource.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.12, 0.22, 0.38)
	sky_material.sky_horizon_color = Color(0.62, 0.70, 0.78)
	sky_material.ground_bottom_color = Color(0.12, 0.14, 0.16)
	sky_material.ground_horizon_color = Color(0.42, 0.46, 0.48)
	sky.sky_material = sky_material
	environment_resource.sky = sky
	environment_resource.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment_resource.ambient_light_energy = 0.7
	environment_resource.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment_resource.fog_enabled = true
	environment_resource.fog_light_color = Color(0.55, 0.63, 0.70)
	environment_resource.fog_density = 0.0015
	environment_resource.glow_enabled = false
	world_environment.environment = environment_resource
	add_child(world_environment)

func _build_rain() -> void:
	rain = GPUParticles3D.new()
	rain.name = "LocalRain"
	rain.amount = maxi(100, rain_particle_count)
	rain.lifetime = 1.3
	rain.emitting = false
	rain.local_coords = true
	rain.visibility_aabb = AABB(Vector3(-30, -8, -30), Vector3(60, 45, 60))
	var process_material := ParticleProcessMaterial.new()
	process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	process_material.emission_box_extents = Vector3(22, 8, 22)
	process_material.direction = Vector3(-0.12, -1.0, 0.0)
	process_material.spread = 4.0
	process_material.gravity = Vector3(0, -12, 0)
	process_material.initial_velocity_min = 17.0
	process_material.initial_velocity_max = 23.0
	process_material.scale_min = 0.8
	process_material.scale_max = 1.2
	rain.process_material = process_material
	var streak := QuadMesh.new()
	streak.size = Vector2(0.025, 0.42)
	var streak_material := StandardMaterial3D.new()
	streak_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	streak_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	streak_material.albedo_color = Color(0.62, 0.78, 0.95, 0.58)
	streak_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	streak.material = streak_material
	rain.draw_pass_1 = streak
	add_child(rain)

func _prepare_existing_scene() -> void:
	sun = get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	if sun:
		sun.light_energy = 1.15
		sun.shadow_enabled = true
		sun.directional_shadow_max_distance = 55.0
	ground_mesh = get_node_or_null("Ground/GroundMesh") as MeshInstance3D
	if ground_mesh:
		ground_material = StandardMaterial3D.new()
		ground_material.albedo_color = Color(0.20, 0.23, 0.25)
		ground_material.roughness = 0.92
		ground_mesh.material_override = ground_material

func _build_status_label() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "GraphicsStatus"
	canvas.layer = 5
	add_child(canvas)
	status_label = Label.new()
	status_label.position = Vector2(24, 700)
	status_label.add_theme_font_size_override("font_size", 13)
	status_label.add_theme_color_override("font_color", Color(0.72, 0.86, 1.0))
	canvas.add_child(status_label)

func _apply_quality() -> void:
	match quality:
		Quality.PERFORMANCE:
			rain.amount = 250
			environment_resource.glow_enabled = false
			environment_resource.ambient_light_energy = 0.8
		Quality.BALANCED:
			rain.amount = mini(rain_particle_count, 700)
			environment_resource.glow_enabled = false
			environment_resource.ambient_light_energy = 0.7
		Quality.QUALITY:
			rain.amount = mini(rain_particle_count, 1200)
			environment_resource.glow_enabled = true
			environment_resource.glow_intensity = 0.25
			environment_resource.ambient_light_energy = 0.75
	_update_status()

func _apply_weather() -> void:
	match weather:
		Weather.CLEAR:
			rain.emitting = false
			environment_resource.fog_density = 0.0015
			if sun:
				sun.light_energy = 1.15
			_set_ground_wetness(false)
		Weather.RAIN:
			rain.emitting = true
			environment_resource.fog_density = 0.006
			environment_resource.fog_light_color = Color(0.38, 0.48, 0.58)
			if sun:
				sun.light_energy = 0.72
			_set_ground_wetness(true)
		Weather.FOG:
			rain.emitting = false
			environment_resource.fog_density = 0.018
			environment_resource.fog_light_color = Color(0.58, 0.64, 0.68)
			if sun:
				sun.light_energy = 0.8
			_set_ground_wetness(false)
	_update_status()

func _set_ground_wetness(is_wet: bool) -> void:
	if not is_instance_valid(ground_material):
		return
	ground_material.roughness = 0.38 if is_wet else 0.92
	ground_material.albedo_color = Color(0.11, 0.14, 0.17) if is_wet else Color(0.20, 0.23, 0.25)

func _update_status() -> void:
	if not is_instance_valid(status_label):
		return
	var weather_name := ["CLEAR", "RAIN", "FOG"][int(weather)]
	var quality_name := ["PERFORMANCE", "BALANCED", "QUALITY"][int(quality)]
	status_label.text = "WEATHER: %s  |  GRAPHICS: %s  |  F6 WEATHER  /  F7 QUALITY" % [weather_name, quality_name]
