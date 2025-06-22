extends Node3D

@export var player:Player;

@onready var static_body_3d: Area3D = $StaticBody3D
@onready var static_body_3d_2: Area3D = $StaticBody3D2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var magic_attack_scene = preload("res://addons/fp_controller/magic_attack.tscn")
@onready var marker_3d: Marker3D = $Marker3D

func _ready() -> void:
	player.attack_1.connect(
		func() -> void:
			if !player.use_magic:
				for body in static_body_3d.get_overlapping_bodies():
					if body is Enemy and player.in_combat and player.is_attacking_1:
						body.deal_damage(1, player)
			else:
				var b:MagicAttack = magic_attack_scene.instantiate()
				get_owner().get_owner().add_child(b)
				b.transform = marker_3d.global_transform
				b.velocity = -b.transform.basis.z * b.muzzle_velocity
	)
	
	player.attack_2.connect(
		func() -> void:
			for body in static_body_3d_2.get_overlapping_bodies():
				if body is Enemy and player.in_combat and player.is_attacking_2:
					body.deal_damage(1, player)
	)

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body is Enemy and player.in_combat and player.is_attacking_1:
		body.deal_damage(1, player)

func _on_static_body_3d_2_body_entered(body: Node3D) -> void:
	if body is Enemy and player.in_combat and player.is_attacking_2:
		body.deal_damage(1, player)
