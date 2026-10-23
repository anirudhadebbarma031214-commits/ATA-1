extends "res://scripts/player.gd"
## Physics-oriented movement override for ATA-1.
## Keeps the existing character setup, camera and switching controls.

@export var ground_acceleration: float = 22.0
@export var air_acceleration: float = 5.0
@export var ground_friction: float = 26.0

func _ready() -> void:
	super._ready()
	gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))
	motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
	floor_snap_length = 0.25
	floor_stop_on_slope = true

func _physics_process(delta: float) -> void:
	if not is_active or get_tree().paused:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif velocity.y < 0.0:
		velocity.y = 0.0

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
	var target_x := direction.x * speed
	var target_z := direction.z * speed
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration

	if direction.length_squared() > 0.001:
		velocity.x = move_toward(velocity.x, target_x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_z, acceleration * delta)
	else:
		var friction := ground_friction if is_on_floor() else ground_friction * 0.15
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)

	move_and_slide()
