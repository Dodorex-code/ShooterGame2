class_name Enemy extends CharacterBody3D

const SPEED:float = 5.0

# health
@onready var health:float = 10.0
@onready var max_health:float = 10.0

# refernce to interactable
@onready var interactable: Interactable = $Interactable

@onready var enemy_deathnote: CanvasLayer = $EnemyDeathnote

# reference to navigation agent 3d -> used for pathfinding
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

# state vars
var can_move:bool = true
var is_dead:bool = false
enum attack_modes {
	ALLWAYS_TOWARDS_PLAYER,
	TOWARDS_PLAYER_HIDING,
	STAY_IN_PLACE_AND_DODGE,
	CHANGE_HIDING_FREQUENT,
	CHANGE_HIDING_SELDOM,
	RUN_AWAY,
	HIDE_AWAY
}
enum enemy_types {
	MELEE,
	GENERIC,
	RANGED,
	SNIPER,
	MEDIC,
	ARSONIST
}
enum enemy_game_state {
	RUNNING_AWAY,
	HIDING,
	PEEKING,
	RELOCATING,
	SUICIDE,
	HEALING,
	BEING_HEALED,
	ATTACKING,
	PATROLING,
	ALERTED,
	HUNGRY
}

# enemy names
var enemy_name = ""
var enemy_backgroud = ""

var names = [
	"Dmitar Volkov",
	"Branislav Horvat",
	"Zoran Petrović",
	"Vladislav Popov",
	"Radomir Ivanov",
	"Gavrilo Stanković",
	"Janko Milošević",
	"Kazimir Belov",
	"Ljubomir Novaković",
	"Tihomir Sokolov",
	
	"Vesna Marković",
	"Zorica Dragić",
	"Jadranka Petrova",
	"Ljudmila Ivanova",
	"Biserka Popović",
	"Slavica Kostić",
	"Milena Stojanović",
	"Danica Nikolić",
	"Ljiljana Jovanović",
	"Radoslava Mihajlović",
	
	"Sasha Belova",
	"Misha Andrić",
	"Nika Dragović",
	"Bogi Pavlov",
	"Luca Markov",
	"Vanja Petrović",
	"Jovi Janković",
	"Reni Popova",
	"Zvezdan Milošev",
	"Toma Nikolić"
]

var backstories = [
	"Works the smelting line, arms crisscrossed with old burns. They smile when called brave—'no heroics here, just no choice.'",
	"The others mutter about their cropped hair and binder straps, but the foreman tolerates them—nobody else volunteers for the toxic waste cleanup.",
	"Stole a manager's jacket and stitched their own name onto it. They wear it defiantly, even in summer heat, sleeves frayed with pride.",
	"Sweeps metal shavings with a limp from an old injury. They feed the factory cats, whispering 'we're all strays here.'",
	"A runaway who lied about their age to get hired. They flinch at loud noises but stand tall when paychecks are short.",
	"Their transition began with stolen hormone pills from the pharmacy truck. Now they save half for others, though it means slower changes.",
	"Keeps a list of every worker hurt on the job. When asked why, they say 'someone has to remember. The boss won't.'",
	"Binds their chest with bandages that chafe in the heat. They hum lullabies to drown out the foreman's slurs.",
	"A former theology student, now covered in acid stained skin. They trace bats in the dust, then wipe them away before break ends.",
	"The only one who remembers every worker's birthday. They save crumbs from their lunch to make tiny cakes, though nobody celebrates anymore.",

	"Her hands are scarred from the textile machines, but she still embroiders flowers on her apron. The others pretend not to notice when she cries into the fabric.",
	"Works the chemical vats without gloves—the acid has eaten her fingerprints away. She laughs when asked why, saying 'what use are prints to a ghost?'",
	"Once a choir singer, now her voice is raw from shouting over the machinery. She mouths the words to hymns nobody hears.",
	"Her husband was crushed by a falling crane, but she still sees his shadow in the factory fog. She polishes his old safety badge every morning.",
	"The only woman in the welding bay, her eyesight ruined by sparks. She refuses goggles—'the dark is kinder than this place anyway.'",
	"Binds her aching hands with rags to keep working. At night, she soaks them in brine, staring at the ceiling until the pain fades to numbness.",
	"Her daughter died in a factory fire last year. Now she clocks in early just to stand where the cribs once were, ashes still clinging to her shoes.",
	"A former nurse, now mopping factory floors. She pockets the discarded painkiller pills, saving them for 'when the ache wins.'",
	"Breathes through a cloth mask, though the smog seeps through. She writes letters to her sister in the West-Ashur countryside, but never sends them.",
	"Her laughter used to echo through the warehouse. Now she just nods, her voice stolen by the endless drone of machinery.",

	"A former miner with lungs blackened by coal dust, now works the night shift at the chemical waste facility. He hums old folk songs to drown out the screams of the machinery, but the melodies only make the others more uneasy.",
	"Lost three fingers to the conveyor belt last winter, but the foreman still docks his pay for 'slow work'. He keeps the severed digits in a jar of formaldehyde as a reminder.",
	"Once a promising engineer, now just another grease-stained mechanic in the factory. He repairs the same broken machine every week, knowing the the higher-ups at Svarog Inc. will never replace it.",
	"The furnace operator hasn't seen sunlight in years—his skin is pale as a corpse. They say he talks to the flames, and they whisper back in crackling tongues.",
	"A hulking man who carries bricks until his spine cracks, then drinks himself numb. His wife left years ago, but he still sets a plate for her every night.",
	"His brother died in a chemical spill, but the his overseer called it 'heart failure'. Now he works the same vats, coughing up blood into his handkerchief.",
	"A former soldier who traded one battlefield for another. The factory's fumes smell like chlorine gas to him, and he flinches at every shift change.",
	"The oldest worker in the district, bent double from decades of lifting. He remembers when the factory was new, when they promised prosperity instead of rust.",
	"Spends his breaks carving little wooden birds, leaving them on the broken fence where children used to play. The foreman burns them when he finds them.",
	"A quiet man who sharpens knives during lunch. The others avoid him since the accident, though nobody can prove it was his fault."
]

func _ready() -> void:
	# set name to random name
	var i:int = randi_range(0, len(names)-1)
	enemy_name = str(names[i])
	enemy_backgroud = str(backstories[i])
	enemy_deathnote.name_label.text = enemy_name
	enemy_deathnote.text_label.text = enemy_backgroud

# deal damage
@warning_ignore("unused_parameter")
func deal_damage(damage:float, origin:Node3D, damage_type:int = 0) -> void:
	health -= damage
	if health <= 0:
		if not is_dead:
			_on_death()

func _on_death() -> void:
	can_move = false
	is_dead = true
	interactable.can_be_interacted_with = true
	
	print(str(enemy_name) + " has been killed")
	#queue_free()

# when this is called the enemy is already dead
@warning_ignore("unused_parameter")
func _on_interactable_on_interact(interaction_partner: Variant, player_reference: Variant) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	enemy_deathnote.show()

# moves enemy to a random location near it
func move_to_random_location() -> void:
	var random_position:Vector3 = Vector3.ZERO
	random_position.x = randf_range(-5, 5)
	random_position.z = randf_range(-5, 5)
	navigation_agent_3d.set_target_position(random_position)
	
func move_to(pos:Vector3) -> void:
	navigation_agent_3d.set_target_position(pos)
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var destiantion:Vector3 = navigation_agent_3d.get_next_path_position()
	var local_destination:Vector3 = destiantion - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * SPEED
	move_and_slide()
