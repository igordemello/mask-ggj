extends Node2D

@export var agent_scene: PackedScene
@export var agent_count := 80
@export var agent_speed := 80.0

@onready var field := $CrowdField
@onready var player := get_parent().get_node("player")

var agents: Array = []

func _ready():
	spawn_agents()

func spawn_agents():
	for i in agent_count:
		var a = agent_scene.instantiate()
		
		await get_tree().create_timer(randf_range(0.2, 1.0)).timeout
		a.active = true

		var angle := randf() * TAU
		var min_dist := 220
		var max_dist := 380
		var dist := randf_range(min_dist, max_dist)

		var offset := Vector2(cos(angle), sin(angle)) * dist
		a.global_position = player.global_position + offset

		add_child(a)
		agents.append(a)


func _physics_process(delta):
	update_field()
	apply_field_to_agents()
	
func update_field():
	field.clear()
	for a in agents:
		field.add_density(a.global_position)

func apply_field_to_agents():
	for a in agents:
		var to_player = player.global_position - a.global_position
		var dist = to_player.length()

		if dist < 24:
			a.velocity = Vector2.ZERO
			continue

		a.velocity = to_player.normalized() * agent_speed
