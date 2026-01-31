extends Area2D

@export var speed: float = 200.0
@export var target_radius: float = 150.0
@export var update_time: float = 3.0

var target_position: Vector2 = Vector2.ZERO
var player: Node2D = null
var timer: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	update_target_position()

func _process(delta):
	if not player: return

	timer += delta
	if timer >= update_time:
		update_target_position()
		timer = 0.0

	var direction = (target_position - global_position).normalized()
	
	if global_position.distance_to(target_position) > 5:
		position += direction * speed * delta

func update_target_position():
	if player:
		var random_angle = randf() * TAU 
		var offset = Vector2(cos(random_angle), sin(random_angle)) * target_radius
		target_position = player.global_position + offset
