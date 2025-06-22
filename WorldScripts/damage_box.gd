extends Node3D

@onready var area_3d: Area3D = $Area3D
@export var use_lightning:bool = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var damage_type = 2
		if use_lightning:
			damage_type = 1
			$AudioStreamPlayer3D.play()
		body.deal_damage(body.max_health, self, damage_type)
