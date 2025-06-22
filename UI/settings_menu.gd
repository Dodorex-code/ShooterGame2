extends Control

@export var main_menu:Control;

func _on_back_button_pressed() -> void:
	if is_instance_valid(main_menu):
		hide()
		main_menu.show()
