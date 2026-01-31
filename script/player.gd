extends CharacterBody2D

const SPEED = 300.0
const ACELL = 2.0
const ROTATION_SPEED := 8.0

var input: Vector2

@onready var sprite: AnimatedSprite2D = $sprite

func get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

func _physics_process(delta : float):
	var playerInput = get_input() 
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACELL)
	
	move_and_slide()
	
	if velocity.length() > 2.0:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

	if velocity.length() > 5.0:
		var target_rotation := velocity.angle() + PI / 2
		sprite.rotation = lerp_angle(
			sprite.rotation,
			target_rotation,
			delta * ROTATION_SPEED
		)
