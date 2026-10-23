extends CanvasLayer

var panel: PanelContainer

func _ready() -> void:
	var info := VBoxContainer.new()
	info.position = Vector2(24, 24)
	add_child(info)
	var title := Label.new()
	title.text = "ATA-1  /  FREE ROAM"
	title.add_theme_font_size_override("font_size", 22)
	info.add_child(title)
	var stats := Label.new()
	stats.text = "HEALTH 100   |   STAMINA 100"
	info.add_child(stats)
	var money := Label.new()
	money.text = "$ 2,500"
	money.position = Vector2(1080, 24)
	money.add_theme_font_size_override("font_size", 22)
	add_child(money)
	var hints := Label.new()
	hints.text = "WASD MOVE   SHIFT SPRINT   SPACE JUMP   MOUSE LOOK   ESC PAUSE"
	hints.position = Vector2(300, 675)
	add_child(hints)
	panel = PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-160, -90)
	panel.custom_minimum_size = Vector2(320, 180)
	panel.visible = false
	add_child(panel)
	var menu := VBoxContainer.new()
	panel.add_child(menu)
	var paused_label := Label.new()
	paused_label.text = "PAUSED"
	paused_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	paused_label.add_theme_font_size_override("font_size", 28)
	menu.add_child(paused_label)
	var resume := Button.new()
	resume.text = "RESUME GAME"
	resume.pressed.connect(_toggle_pause)
	menu.add_child(resume)
	var quit_button := Button.new()
	quit_button.text = "QUIT GAME"
	quit_button.pressed.connect(_quit_game)
	menu.add_child(quit_button)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE and not event.echo:
		_toggle_pause()
		get_viewport().set_input_as_handled()

func _toggle_pause() -> void:
	var pausing := not get_tree().paused
	get_tree().paused = pausing
	panel.visible = pausing
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pausing else Input.MOUSE_MODE_CAPTURED

func _quit_game() -> void:
	get_tree().quit()
