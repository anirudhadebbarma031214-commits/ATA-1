extends CanvasLayer

func _ready() -> void:
	var label := Label.new()
	label.text = "ATA-1  |  FREE ROAM  |  WASD MOVE  |  SHIFT SPRINT  |  SPACE JUMP  |  ESC PAUSE"
	label.position = Vector2(24, 24)
	add_child(label)
