extends Control
@export var player:Player;
@onready var label: Label = $Label

func _ready() -> void:
	hide()

func death_msg(msg:String):
	show()
	label.text = msg
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	hide()
	player.respawn()
