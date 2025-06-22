class_name MagicAttack extends Area3D


@export var muzzle_velocity = 25
@export var g = Vector3.DOWN * 20

var damage:int = 2

var velocity = Vector3.ZERO


func _physics_process(delta):
	velocity += g * delta
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin -= velocity * delta

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.deal_damage(damage, get_tree().get_first_node_in_group("Player"))
	elif ! body.is_in_group("Player"):
		queue_free()
