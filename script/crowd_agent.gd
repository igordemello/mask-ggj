extends CharacterBody2D

var active := false

func _physics_process(delta):
	if not active:
		return
	move_and_slide()
