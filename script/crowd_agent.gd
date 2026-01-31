extends CharacterBody2D

var active := false

@export var separation_radius := 16.0
@export var separation_strength := 0.6

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var rotation_speed := 8.0

func _physics_process(delta):
	if not active:
		return
	move_and_slide()
	
func _process(delta):
	if velocity.length() < 0.1:
		return

	var target_angle := velocity.angle() + PI / 2
	sprite.rotation = lerp_angle(
		sprite.rotation,
		target_angle,
		rotation_speed * delta
	)
	
func apply_separation(neighbors: Array):
	var force := Vector2.ZERO
	for other in neighbors:
		var diff = global_position - other.global_position
		var dist = diff.length()
		if dist > 0 and dist < separation_radius:
			force += diff.normalized() * (1.0 - dist / separation_radius)
	
	velocity += force * separation_strength
