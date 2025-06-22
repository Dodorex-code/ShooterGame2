extends Node

@export var speed:float = 1.0;
@export var object_to_rotate:Node3D;
@export var rotation_axis:Vector3 = Vector3(0,0,1)

func _process(delta: float) -> void:
	if is_instance_valid(object_to_rotate):
		object_to_rotate.rotation.x += rotation_axis.x * (speed * delta)
		object_to_rotate.rotation.y += rotation_axis.y * (speed * delta)
		object_to_rotate.rotation.z += rotation_axis.z * (speed * delta)
