extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_velocity: float = 4.5
var gravity: float = 18.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
        if not _jump_was_pressed:
            velocity.y = jump_velocity
    _jump_was_pressed = Input.is_key_pressed(KEY_SPACE)

    var x_input := float(Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT))
    var z_input := float(Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) - float(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
    var direction := Vector3(x_input, 0.0, z_input).normalized()

    if direction.length() > 0.0:
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
    else:
        velocity.x = move_toward(velocity.x, 0.0, move_speed)
        velocity.z = move_toward(velocity.z, 0.0, move_speed)

    move_and_slide()

var _jump_was_pressed: bool = false
