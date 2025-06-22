class_name InteractionSymbol extends CanvasLayer

# reference to texture rect that displays interact key texture
@onready var tr_interact_key: TextureRect = $Control/TextureRectInteractKey

# stuff to setup the interact key texture / it's texture rect
@export_category("UI")
@export var interact_key_texture:Texture2D = preload("res://Assets/UI/keyboard_e.png")
@export var texture_scale:Vector2 = Vector2(0.5, 0.5)
@export var texture_offset:Vector2 = Vector2(64, 64)

func _ready() -> void:
	# setup parameters from export variables
	tr_interact_key.texture = interact_key_texture
	tr_interact_key.scale = texture_scale
	tr_interact_key.pivot_offset = texture_offset
	
	hide()
