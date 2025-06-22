extends Node3D

@export var player:CharacterBody3D;
# Raycast for dynaimc footsteps and footstep stream player
@onready var footstep_stream_player: AudioStreamPlayer3D = $FootstepStreamPlayer
@onready var physics_ray_cast_3d: RayCast3D = $PhysicsRayCast3D
# variables to control how footsteps are simulated
@onready var step_interval:float = 0.45 # time between footsteps
@onready var step_threshhold:float = 0.75 # minimum speed before playing footsteps
@onready var sound_map:Dictionary = {
	"ClothSFX": preload("res://Assets/SFX/Footsteps/Sand.wav"),
	"ConcreteSFX": preload("res://Assets/SFX/Footsteps/Concrete 1.wav"),
	"MetalSFX": preload("res://Assets/SFX/Footsteps/footstep_metal.wav"),
	"RoadSFX": preload("res://Assets/SFX/Footsteps/Gravel 1.wav"),
	"WoodSFX": preload("res://Assets/SFX/Footsteps/Forest 2.wav"),
	"SandSFX": preload("res://Assets/SFX/Footsteps/Sand.wav")
}
# randomize pitch
@onready var pitch_min:float = 0.9
@onready var pitch_max:float = 1.1
# step timer to count down inverval
var _step_counter:float = 0.0

func _ready() -> void:
	_step_counter = step_interval

func _physics_process(delta: float) -> void:
	if player.is_on_floor() and player.velocity.length() >= step_threshhold:
		_step_counter -= delta
		if _step_counter <= 0:
			play_footstep()
			_step_counter = step_interval # workls like a reset timer
			
func play_footstep() -> void:
	if physics_ray_cast_3d.is_colliding():
		var collider = physics_ray_cast_3d.get_collider()
		var material_name = "ConcreteSFX" # default
		if collider:
			if collider.is_in_group("ClothSFX"):
				material_name = "ClothSFX"
			elif collider.is_in_group("ConcreteSFX"):
				material_name = "ConcreteSFX"
			elif collider.is_in_group("MetalSFX"):
				material_name = "MetalSFX"
			elif collider.is_in_group("RoadSFX"):
				material_name = "RoadSFX"
			elif collider.is_in_group("WoodSFX"):
				material_name = "WoodSFX"
			elif collider.is_in_group("SandSFX"):
				material_name = "SandSFX"
			
		if sound_map.has(material_name):
			footstep_stream_player.stream = sound_map[material_name]
		else:
			footstep_stream_player.stream = sound_map["SandSFX"]
			
		footstep_stream_player.pitch_scale = randf_range(pitch_min, pitch_max)
		footstep_stream_player.play()
