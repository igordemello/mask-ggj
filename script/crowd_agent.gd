extends CharacterBody2D

var active := false

@export var separation_radius := 16.0
@export var separation_strength := 0.6

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var rotation_speed := 8.0

var dying := false

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


func dissipate(from_position: Vector2):
	if dying:
		return

	dying = true
	set_physics_process(false)

	var dir := (global_position - from_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.UP

	global_position += dir * 6

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.tween_callback(queue_free)
