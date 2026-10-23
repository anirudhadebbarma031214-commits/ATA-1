extends Node3D
## Cinematic story director for ATA-1.
## Plays an opening camera sequence at launch. Press C to replay it.
## Uses the existing world and player; no extra assets required.

var cinematic_camera: Camera3D
var overlay: CanvasLayer
var top_bar: ColorRect
var bottom_bar: ColorRect
var title_label: Label
var subtitle_label: Label
var dialogue_label: Label
var playing := false
var active_player: Node3D
var gameplay_camera: Camera3D

func _ready() -> void:
	_build_camera()
	_build_overlay()
	call_deferred("_play_opening")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_C and not playing:
		_play_opening()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if playing:
		return
	if is_instance_valid(gameplay_camera):
		gameplay_camera.current = true

func _build_camera() -> void:
	cinematic_camera = Camera3D.new()
	cinematic_camera.name = "CinematicCamera"
	cinematic_camera.current = false
	cinematic_camera.fov = 55.0
	add_child(cinematic_camera)

func _build_overlay() -> void:
	overlay = CanvasLayer.new()
	overlay.layer = 20
	add_child(overlay)
	top_bar = ColorRect.new()
	top_bar.color = Color(0, 0, 0, 1)
	top_bar.anchor_right = 1.0
	top_bar.offset_bottom = 0.0
	top_bar.custom_minimum_size = Vector2(0, 0)
	overlay.add_child(top_bar)
	bottom_bar = ColorRect.new()
	bottom_bar.color = Color(0, 0, 0, 1)
	bottom_bar.anchor_top = 1.0
	bottom_bar.anchor_right = 1.0
	bottom_bar.offset_top = 0.0
	overlay.add_child(bottom_bar)
	title_label = Label.new()
	title_label.anchor_left = 0.07
	title_label.anchor_top = 0.62
	title_label.anchor_right = 0.93
	title_label.anchor_bottom = 0.74
	title_label.add_theme_font_size_override("font_size", 36)
	title_label.add_theme_color_override("font_color", Color(0.2, 0.85, 1.0))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	overlay.add_child(title_label)
	subtitle_label = Label.new()
	subtitle_label.anchor_left = 0.07
	subtitle_label.anchor_top = 0.74
	subtitle_label.anchor_right = 0.93
	subtitle_label.anchor_bottom = 0.81
	subtitle_label.add_theme_font_size_override("font_size", 18)
	subtitle_label.add_theme_color_override("font_color", Color(1, 1, 1))
	overlay.add_child(subtitle_label)
	dialogue_label = Label.new()
	dialogue_label.anchor_left = 0.08
	dialogue_label.anchor_top = 0.84
	dialogue_label.anchor_right = 0.92
	dialogue_label.anchor_bottom = 0.95
	dialogue_label.add_theme_font_size_override("font_size", 20)
	dialogue_label.add_theme_color_override("font_color", Color(1, 0.88, 0.62))
	dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	overlay.add_child(dialogue_label)
	_set_bars(0.0)

func _set_bars(amount: float) -> void:
	var height := 64.0 * amount
	top_bar.offset_bottom = height
	bottom_bar.offset_top = -height

func _play_opening() -> void:
	if playing:
		return
	active_player = _find_active_player()
	if not is_instance_valid(active_player):
		return
	gameplay_camera = active_player.get_node_or_null("CameraRig/SpringArm3D/Camera3D") as Camera3D
	if not is_instance_valid(gameplay_camera):
		return
	playing = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	gameplay_camera.current = false
	cinematic_camera.current = true
	title_label.modulate.a = 0.0
	subtitle_label.modulate.a = 0.0
	dialogue_label.modulate.a = 0.0
	_set_bars(0.0)
	var target := active_player.global_position
	cinematic_camera.global_position = target + Vector3(0, 7, 13)
	cinematic_camera.look_at(target + Vector3(0, 1, 0), Vector3.UP)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_method(_set_bars, 0.0, 1.0, 0.7)
	tween.tween_property(title_label, "modulate:a", 1.0, 0.9).set_delay(0.5)
	tween.tween_property(subtitle_label, "modulate:a", 1.0, 0.9).set_delay(0.8)
	await tween.finished
	title_label.text = "ATA-1 PRESENTS"
	subtitle_label.text = "A STORY FROM THE NORTHEAST"
	dialogue_label.text = "AGARTALA, TRIPURA  •  6:15 PM"
	dialogue_label.modulate.a = 1.0
	await get_tree().create_timer(1.7).timeout
	title_label.text = "CHAPTER ONE"
	subtitle_label.text = "THE CITY NEVER STOPS"
	dialogue_label.text = "Alex: New city. New start. Let's see where this road goes."
	var move := create_tween()
	move.tween_property(cinematic_camera, "global_position", target + Vector3(8, 4, 9), 2.4)
	move.parallel().tween_method(func(v: float): cinematic_camera.look_at(active_player.global_position + Vector3(0, 1, 0), Vector3.UP), 0.0, 1.0, 2.4)
	await move.finished
	await get_tree().create_timer(1.4).timeout
	var fade := create_tween()
	fade.set_parallel(true)
	fade.tween_property(title_label, "modulate:a", 0.0, 0.6)
	fade.tween_property(subtitle_label, "modulate:a", 0.0, 0.6)
	fade.tween_property(dialogue_label, "modulate:a", 0.0, 0.6)
	fade.tween_method(_set_bars, 1.0, 0.0, 0.6)
	await fade.finished
	cinematic_camera.current = false
	gameplay_camera.current = true
	playing = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _find_active_player() -> Node3D:
	for character in get_tree().get_nodes_in_group("playable_characters"):
		if character.get("is_active") == true:
			return character as Node3D
	return get_tree().get_first_node_in_group("playable_characters") as Node3D
