extends CanvasLayer

var panel: PanelContainer
var phone_panel: PanelContainer
var character_label: Label
var character_switcher: PanelContainer
var character_buttons: Dictionary = {}
var phone_title: Label
var phone_content: Label
var phone_home: GridContainer
var phone_open := false
var active_app := "HOME"

func _ready() -> void:
	var info := VBoxContainer.new()
	info.position = Vector2(24, 24)
	add_child(info)
	var title := Label.new()
	title.text = "ATA-1  /  FREE ROAM"
	title.add_theme_font_size_override("font_size", 22)
	info.add_child(title)
	character_label = Label.new()
	character_label.add_theme_font_size_override("font_size", 17)
	info.add_child(character_label)
	var stats := Label.new()
	stats.text = "HEALTH 100   |   STAMINA 100"
	info.add_child(stats)
	var money := Label.new()
	money.text = "$ 2,500"
	money.position = Vector2(1080, 24)
	money.add_theme_font_size_override("font_size", 22)
	add_child(money)
	var hints := Label.new()
	hints.text = "WASD MOVE   SHIFT SPRINT   SPACE JUMP   MOUSE LOOK   1/2/3 SWITCH   P PHONE   ESC PAUSE"
	hints.position = Vector2(180, 675)
	add_child(hints)
	_build_pause_menu()
	_build_phone()
	_build_character_switcher()

func _build_pause_menu() -> void:
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

func _build_phone() -> void:
	phone_panel = PanelContainer.new()
	phone_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	phone_panel.position = Vector2(250, -265)
	phone_panel.custom_minimum_size = Vector2(300, 530)
	phone_panel.visible = false
	phone_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(phone_panel)

	var shell := VBoxContainer.new()
	shell.add_theme_constant_override("separation", 12)
	phone_panel.add_child(shell)

	var status := Label.new()
	status.text = "● ATA MOBILE                                      100%"
	status.add_theme_font_size_override("font_size", 12)
	shell.add_child(status)

	phone_title = Label.new()
	phone_title.text = "ATA PHONE"
	phone_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phone_title.add_theme_font_size_override("font_size", 25)
	shell.add_child(phone_title)

	var divider := HSeparator.new()
	shell.add_child(divider)

	phone_content = Label.new()
	phone_content.text = "Welcome to ATA Mobile."
	phone_content.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phone_content.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	phone_content.custom_minimum_size = Vector2(260, 100)
	phone_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	shell.add_child(phone_content)

	phone_home = GridContainer.new()
	phone_home.columns = 2
	phone_home.add_theme_constant_override("h_separation", 12)
	phone_home.add_theme_constant_override("v_separation", 12)
	shell.add_child(phone_home)
	_add_phone_app("CONTACTS", "CONTACTS")
	_add_phone_app("MESSAGES", "MESSAGES")
	_add_phone_app("MAP", "MAP")
	_add_phone_app("CAMERA", "CAMERA")
	_add_phone_app("SETTINGS", "SETTINGS")
	_add_phone_app("HOME", "HOME")

	var close_button := Button.new()
	close_button.text = "CLOSE PHONE  [P]"
	close_button.custom_minimum_size = Vector2(0, 42)
	close_button.pressed.connect(_toggle_phone)
	shell.add_child(close_button)

func _add_phone_app(button_text: String, app_name: String) -> void:
	var app_button := Button.new()
	app_button.text = button_text
	app_button.custom_minimum_size = Vector2(125, 54)
	app_button.pressed.connect(_open_phone_app.bind(app_name))
	phone_home.add_child(app_button)


func _build_character_switcher() -> void:
	character_switcher = PanelContainer.new()
	character_switcher.position = Vector2(24, 118)
	character_switcher.custom_minimum_size = Vector2(190, 0)
	add_child(character_switcher)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	character_switcher.add_child(column)

	var heading := Label.new()
	heading.text = "CHARACTER SELECT"
	heading.add_theme_font_size_override("font_size", 15)
	column.add_child(heading)

	var subtitle := Label.new()
	subtitle.text = "Choose your protagonist"
	subtitle.add_theme_font_size_override("font_size", 11)
	column.add_child(subtitle)

	for info in [
		{"index": 1, "name": "ALEX", "role": "01  •  THE LEAD", "color": Color(0.12, 0.48, 0.95)},
		{"index": 2, "name": "MAYA", "role": "02  •  THE DRIVER", "color": Color(0.95, 0.32, 0.10)},
		{"index": 3, "name": "RAVI", "role": "03  •  THE FIXER", "color": Color(0.12, 0.72, 0.34)}
	]:
		var button := Button.new()
		button.text = info["name"] + "   /   " + info["role"]
		button.custom_minimum_size = Vector2(170, 46)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_color_override("font_color", info["color"])
		button.pressed.connect(_select_character.bind(info["index"]))
		column.add_child(button)
		character_buttons[info["index"]] = button

	var hint := Label.new()
	hint.text = "HOTKEYS  1  /  2  /  3"
	hint.add_theme_font_size_override("font_size", 11)
	column.add_child(hint)

func _select_character(target_index: int) -> void:
	for character in get_tree().get_nodes_in_group("playable_characters"):
		character.is_active = character.character_index == target_index
		character.game_camera.current = character.is_active
	_update_character_buttons()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _update_character_buttons() -> void:
	for character in get_tree().get_nodes_in_group("playable_characters"):
		if character_buttons.has(character.character_index):
			var button: Button = character_buttons[character.character_index]
			button.text = ("▶  " if character.is_active else "    ") + character.character_name + "   /   " + str(character.character_index)
			button.disabled = character.is_active

func _process(_delta: float) -> void:
	_update_character_buttons()
	for character in get_tree().get_nodes_in_group("playable_characters"):
		if character.is_active:
			character_label.text = "CHARACTER " + str(character.character_index) + "  /  " + character.character_name
			if phone_open:
				phone_title.text = character.character_name + "'S PHONE"
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_P:
			_toggle_phone()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE:
			if phone_open:
				_toggle_phone()
			else:
				_toggle_pause()
			get_viewport().set_input_as_handled()

func _toggle_phone() -> void:
	phone_open = not phone_open
	phone_panel.visible = phone_open
	if phone_open:
		active_app = "HOME"
		_show_phone_home()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if not get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _show_phone_home() -> void:
	phone_content.text = "Your city. Your life.\nChoose an app below."
	phone_home.visible = true

func _open_phone_app(app_name: String) -> void:
	active_app = app_name
	phone_title.text = app_name
	phone_home.visible = false
	match app_name:
		"CONTACTS":
			phone_content.text = "CONTACTS\n\nAlex\nMaya\nRavi\nMom\nDad\n\nCalling is not connected yet."
		"MESSAGES":
			phone_content.text = "MESSAGES\n\nNo new messages.\nMessaging will be connected later."
		"MAP":
			phone_content.text = "CITY MAP\n\nMap screen placeholder.\nThe open-world map will be added next."
		"CAMERA":
			phone_content.text = "CAMERA\n\nCamera app ready for a future screenshot feature."
		"SETTINGS":
			phone_content.text = "SETTINGS\n\nATA Mobile\nCharacter switching: 1 / 2 / 3\nPhone shortcut: P"
		_:
			_show_phone_home()
	if app_name == "HOME":
		_show_phone_home()

func _toggle_pause() -> void:
	var pausing := not get_tree().paused
	get_tree().paused = pausing
	panel.visible = pausing
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pausing else Input.MOUSE_MODE_CAPTURED

func _quit_game() -> void:
	get_tree().quit()
