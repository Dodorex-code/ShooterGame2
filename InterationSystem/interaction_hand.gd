class_name InteractionHand extends RayCast3D

# set destiantion for RayCast3D
@export_category("RayCast")
@export var ray_target:Vector3 = Vector3(0,0,-2)

@export_category("Interaction Logic")
# is this interaction_hand used by the player (which uses the keyboard
# and mouse) or is it used by something else e.g. an enemy (which
# handles interaction verry diffrently)
@export var is_for_player:bool = true

# define interaction event
@onready var INTERACTION_KEY:String = "interact"

# preload interaction_symbol UI scene
@onready var interaction_symbol_scene = preload("res://InterationSystem/interaction_symbol.tscn")

# reference to interaction symbol scene afer instatiaton
var interaction_symbol_reference:InteractionSymbol = null

# reference to player
var player_reference:CharacterBody3D

func _ready() -> void:
	# check if input mapping exists for interact key
	if !InputMap.has_action(INTERACTION_KEY):
		push_error("No control mapped for 'interact', using default...")
		# add "interact" as a input with the button "E"
		var event = InputEventKey.new()
		event.keycode = KEY_E
		InputMap.add_action(INTERACTION_KEY)
		InputMap.action_add_event(INTERACTION_KEY, event)
	
	# if the group "Player" does not exitst then throw error and quit
	if get_tree().get_nodes_in_group("Player").is_empty():
		assert(false, "For the Interaction System to work you MUST add your player to the global group 'Player' (this is case sensitive!) or create the global group 'Player' (this is case sensitive!) and add your player to it")
	else:
		# set player_reference as the first node in the group "Player"
		player_reference = get_tree().get_first_node_in_group("Player")
		
	if is_for_player:
		# check that player reference is valid
		# if not the throw error and exit the game
		if !is_instance_valid(player_reference):
			assert(false, "Invalid player reference for InteractionHand. Please verify that the global group 'Player' (this is case sensitive!) exists and that your player is the first (and hopfully only) Node in it")
		else:
			# instatiate the interaction symbol and add it as a child
			interaction_symbol_reference = interaction_symbol_scene.instantiate()
			add_child(interaction_symbol_reference)

	# set destiantion for raycast
	target_position = ray_target
		
# fire ray every tick
func _process(_delta: float) -> void:
	if is_colliding():
		# show interaction symbol if this node is used by player
		if is_for_player:
			if _can_be_interacted_with(get_collider()) != null:
				interaction_symbol_reference.show()
			else:
				interaction_symbol_reference.hide()
		# only handle interact after key has actually been pressed or if
		# the owner of this node is not the player
		if Input.is_action_just_pressed(INTERACTION_KEY) or !is_for_player:
			_handle_interact(get_collider())
	# hide interaction symbol if it is not being needed
	elif is_for_player:
			interaction_symbol_reference.hide()

# handle collision
func _handle_interact(collider) -> void:
	var obj = _can_be_interacted_with(collider)
	if obj != null:
		obj.on_interact.emit(owner, player_reference)

func _can_be_interacted_with(collider):
	if is_instance_valid(collider):
		# check if the node itself or any children of it are of class "Interactable"
		# check if node iself is of class "Interactable"
		if collider is Interactable:
			if collider.can_be_interacted_with:
				return collider
			else:
				return null
		# avoid interaction with self
		#elif collider is InteractionHand:
			#return null
		# check if nodes children are of class "Interactable"
		for child_node in collider.get_children():
			if child_node is Interactable:
				if child_node.can_be_interacted_with:
					return child_node
			# avoid interaction with self
			#elif collider is InteractionHand:
				#return null
	return null
