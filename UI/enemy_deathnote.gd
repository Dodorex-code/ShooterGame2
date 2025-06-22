extends CanvasLayer

@onready var name_label: Label = $Control/NameLabel
@onready var text_label: Label = $Control/TextLabel

func _ready() -> void:
	hide()

func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
