extends Node3D
@export var node:Node3D;


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and is_instance_valid(node):
		node.hide()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and is_instance_valid(node):
		node.show()
