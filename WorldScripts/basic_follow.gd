extends Node3D
@export var Target:Node3D;
@export var offset:Vector3 = Vector3(0,10,0)

func _ready() -> void:
	if not is_instance_valid(Target):
		push_error("Invalid Target reference for basic_follow.gd script")

func _process(_delta: float) -> void:
	global_position = Target.global_position + offset
