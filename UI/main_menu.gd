extends Control

@export var settings_menu:Control;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/L0.tscn")


func _on_settings_button_pressed() -> void:
	if is_instance_valid(settings_menu):
		hide()
		settings_menu.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
