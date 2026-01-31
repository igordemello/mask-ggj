extends CharacterBody2D

const SPEED = 300.0
const ACELL = 2.0

var input: Vector2

func get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

func _physics_process(delta : float):
	var playerInput = get_input() 
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACELL)
	
	move_and_slide()
	return
	
	
	
	
