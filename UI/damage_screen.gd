extends Control

@export var player:Player;
@onready var sprites = [$I1,$I2,$I3,$I4,$I5,$I6,$I7,$I8,$I9]
@onready var fps_label: Label = $FPS_Label

func _ready() -> void:
	if not is_instance_valid(player):
		push_error("Invalid player reference")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		for sprite:TextureRect in sprites:
			sprite.rotation = randf_range(0,360)
			sprite.modulate = Color(1,1,1,0)
			
func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func update_damage_screen() -> void:
	for sprite:TextureRect in sprites:
		sprite.modulate = Color(1,1,1,1-(player.health/player.max_health))
		sprite.rotation = randf_range(0,360)
