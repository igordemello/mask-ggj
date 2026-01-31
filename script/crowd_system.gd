extends Node2D

@export var agent_scene: PackedScene
@export var agent_count := 80
@export var agent_speed := 80.0

@onready var field := $CrowdField
@onready var player := get_parent().get_node("player")

@export var neighbor_radius := 20.0

@export var dissipate_radius := 64.0

@export var initial_agent_count := 250
@export var min_spawn_distance := 48.0

@onready var spawn_area: Polygon2D = $SpawnArea

var agents: Array = []

var spatial_hash := {}
@export var cell_size := 32.0

var field_timer := 0.0
@export var field_update_rate := 0.1

func _ready():
	spawn_initial_crowd()
	player.damaged.connect(on_player_damaged)

func spawn_agents():
	for i in agent_count:
		var angle := randf() * TAU
		var dist := randf_range(220, 380)
		var offset := Vector2(cos(angle), sin(angle)) * dist
		spawn_agent_at_position(player.global_position + offset)


func _physics_process(delta):
	field_timer += delta
	if field_timer >= field_update_rate:
		field_timer = 0
		update_field()

	rebuild_spatial_hash()
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
		if randf() < 0.4:
			a.apply_separation(neighbors)

		a.velocity = a.velocity.limit_length(agent_speed)


func get_neighbors(agent):
	var result := []
	var base := get_cell(agent.global_position)

	for x in range(-1, 2):
		for y in range(-1, 2):
			var cell := base + Vector2i(x, y)
			if spatial_hash.has(cell):
				for other in spatial_hash[cell]:
					if other != agent:
						if agent.global_position.distance_to(other.global_position) <= neighbor_radius:
							result.append(other)

	return result


func on_player_damaged():
	dissipate_near_player()


func dissipate_near_player():
	var to_remove := []

	for a in agents:
		if a.global_position.distance_to(player.global_position) <= dissipate_radius:
			to_remove.append(a)

	for a in to_remove:
		agents.erase(a)
		a.dissipate(player.global_position)


func get_random_point_in_polygon(polygon: PackedVector2Array) -> Vector2:
	var bounds := Rect2(polygon[0], Vector2.ZERO)
	for p in polygon:
		bounds = bounds.expand(p)

	for i in 100:
		var point := Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y)
		)

		if Geometry2D.is_point_in_polygon(point, polygon):
			return point

	return polygon[0] # fallback


func spawn_initial_crowd():
	var poly := spawn_area.polygon

	for i in initial_agent_count:
		var pos := get_random_point_in_polygon(poly)

		if pos.distance_to(player.global_position) < min_spawn_distance:
			i -= 1
			continue

		spawn_agent_at_position(pos)


func spawn_agent_at_position(pos: Vector2):
	var a = agent_scene.instantiate()
	a.global_position = pos
	a.active = true
	add_child(a)
	agents.append(a)


func get_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / cell_size),
		floor(pos.y / cell_size)
	)
	
func rebuild_spatial_hash():
	spatial_hash.clear()
	for a in agents:
		var cell := get_cell(a.global_position)
		if not spatial_hash.has(cell):
			spatial_hash[cell] = []
		spatial_hash[cell].append(a)
