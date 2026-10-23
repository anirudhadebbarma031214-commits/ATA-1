extends CharacterBody3D

@export var character_index: int = 1
@export var character_name: String = "ALEX"
@export var is_active: bool = false
@export var walk_speed: float = 5.5
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.0025

var gravity: float = 18.0
var camera_yaw: float = 0.0
var camera_pitch: float = -0.18
var jump_was_pressed: bool = false
@onready var camera_rig: Node3D = $CameraRig
@onready var game_camera: Camera3D = $CameraRig/SpringArm3D/Camera3D
@onready var body_mesh: MeshInstance3D = $BodyMesh

func _ready() -> void:
	add_to_group("playable_characters")
	camera_rig.position = Vector3(0, 1.5, 0)
	camera_rig.rotation = Vector3(camera_pitch, camera_yaw, 0)
	game_camera.current = is_active
	var body_material := StandardMaterial3D.new()
	match character_index:
		1:
			body_material.albedo_color = Color(0.15, 0.55, 1.0)
		2:
			body_material.albedo_color = Color(1.0, 0.42, 0.12)
		3:
			body_material.albedo_color = Color(0.25, 0.9, 0.45)
	body_mesh.material_override = body_material

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_3:
			_switch_character(event.keycode - KEY_0)
	if not is_active:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_yaw -= event.relative.x * mouse_sensitivity
		camera_pitch = clamp(camera_pitch - event.relative.y * mouse_sensitivity, -0.9, 0.35)
		camera_rig.rotation = Vector3(camera_pitch, camera_yaw, 0)
	if event is InputEventMouseButton and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and not get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _switch_character(target_index: int) -> void:
	for character in get_tree().get_nodes_in_group("playable_characters"):
		character.is_active = character.character_index == target_index
		character.game_camera.current = character.is_active
	if is_active:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_active or get_tree().paused:
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	var jump_pressed := Input.is_key_pressed(KEY_SPACE)
	if jump_pressed and is_on_floor() and not jump_was_pressed:
		velocity.y = jump_velocity
	jump_was_pressed = jump_pressed
	var input_x := float(Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT))
	var input_z := float(Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) - float(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
	var input_vector := Vector2(input_x, input_z).normalized()
	var forward := Vector3(-sin(camera_yaw), 0, -cos(camera_yaw))
	var right := Vector3(cos(camera_yaw), 0, -sin(camera_yaw))
	var direction := (right * input_vector.x + forward * -input_vector.y).normalized()
	var speed := sprint_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed
	if direction.length() > 0.01:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed * 5.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed * 5.0 * delta)
	move_and_slide()
