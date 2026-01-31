extends Node2D

@export var agent_scene: PackedScene
@export var agent_count := 80
@export var agent_speed := 80.0

@onready var field := $CrowdField
@onready var player := get_parent().get_node("player")

@export var neighbor_radius := 20.0

@export var dissipate_radius := 64.0

var agents: Array = []

func _ready():
	spawn_agents()
	player.damaged.connect(on_player_damaged)

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

		var neighbors = get_neighbors(a)
		a.apply_separation(neighbors)

		a.velocity = a.velocity.limit_length(agent_speed)


func get_neighbors(agent):
	var result := []
	for other in agents:
		if other == agent:
			continue
		if agent.global_position.distance_to(other.global_position) <= neighbor_radius:
			result.append(other)
	return result


func on_player_damaged():
	dissipate_near_player()


func dissipate_near_player():
	for a in agents:
		if a.global_position.distance_to(player.global_position) <= dissipate_radius:
			agents.erase(a)
			a.dissipate(player.global_position)
