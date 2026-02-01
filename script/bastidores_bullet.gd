extends Area2D

@export var speed := 600.0
@export var lifetime := 0.8
@export var knockback_strength := 700.0

var direction := Vector2.ZERO

func _ready():
	$CollisionShape2D.disabled = false

func _physics_process(delta):
	global_position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body):
	if body.has_method("apply_knockback"):
		body.apply_knockback(direction, knockback_strength)
