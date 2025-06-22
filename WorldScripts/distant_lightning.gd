extends Node3D

@export var world_env:WorldEnvironment;

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var brightness:float = 16.0
@export var interval_min:float = 9.0
@export var interval_max:float = 28.0

var _countdown:float = 0.0
var _has_started:bool = false
var _temp_brightness:float = 0.0

func _ready() -> void:
	if not is_instance_valid(world_env):
		push_error("invalid world envionrnment instance")
	else:
		_temp_brightness = world_env.environment.adjustment_brightness
		_countdown = randf_range(interval_min, interval_max)
		_has_started = true

func _process(delta: float) -> void:
	if _has_started:
		_countdown -= delta
		if _countdown <= 0:
			_on_strike()
			_has_started = false

func _on_strike() -> void:
	world_env.environment.adjustment_brightness = brightness
	world_env.environment.background_energy_multiplier = _temp_brightness
	audio_stream_player_2d.play()
	_countdown = randf_range(interval_min, interval_max)
	_has_started = true
