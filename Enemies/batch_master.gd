extends Node3D

var enemies = []
var hiding_spots = []
var player:Player

func _ready() -> void:
	
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
		elif child is HidingSpot:
			hiding_spots.append(child)
	
	player = get_tree().get_first_node_in_group("Player")

func get_player_position() -> Vector3:
	return player.global_position
	
func get_random_hiding_spot_position() -> Vector3:
	return hiding_spots[randi_range(0, len(hiding_spots)-1)].global_position

func get_nearest_hiding_spot_position(enemy:Enemy) -> Vector3:
	var pos:Vector3 = Vector3.ZERO
	var distance:float = 100000000.0
	for spot:HidingSpot in hiding_spots:
		if spot.global_position.distance_to(enemy.global_position) < distance:
			distance = spot.global_position.distance_to(enemy.global_position)
			pos = spot.global_position
	return pos

func make_enemies_scatter() -> void:
	var counter = 0
	for enemy:Enemy in enemies:
		enemy.move_to(hiding_spots[counter].global_position)
		counter += 1
		if counter > len(hiding_spots)-1:
			counter = 0

func make_all_enemies_move_to(pos:Vector3) -> void:
	for enemy:Enemy in enemies:
		enemy.move_to(pos)

func make_all_enemies_move_to_random_hiding_spot() -> void:
	make_all_enemies_move_to(get_random_hiding_spot_position())
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("slot3"):
		make_enemies_scatter()
	if Input.is_action_just_pressed("slot4"):
		make_all_enemies_move_to_random_hiding_spot()
