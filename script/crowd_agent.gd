extends CharacterBody2D

var active := false

@export var separation_radius := 16.0
@export var separation_strength := 0.6

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var rotation_speed := 8.0

var dying := false

var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0

var polarization_side := 0 # -1 = esquerda | 1 = direita
var collision_disabled := false

var frozen := false
var frozen_timer := 0.0

var speed_multiplier := 1.0
var slow_timer := 0.0

func disable_agent_collision():
	if collision_disabled:
		return
	collision_disabled = true
	$CollisionShape2D.disabled = false

func enable_agent_collision():
	if not collision_disabled:
		return
	collision_disabled = false
	$CollisionShape2D.disabled = false

func assign_polarization():
	polarization_side = -1 if randf() < 0.5 else 1

func apply_knockback(dir: Vector2, strength: float, duration := 0.35):
	knockback_velocity = dir.normalized() * strength
	knockback_timer = duration

func _ready() -> void:
	randomize()
	sprite.play(str(randi_range(1, 3)))

func _physics_process(delta):
	if not active:
		return

	if frozen:
		frozen_timer -= delta
		velocity = Vector2.ZERO

		if frozen_timer <= 0.0:
			unfreeze()

		move_and_slide()
		return

	if knockback_timer > 0.0:
		knockback_timer -= delta
	else:
		knockback_velocity = Vector2.ZERO

	if knockback_timer > 0.0:
		velocity = knockback_velocity
	else:
		velocity *= 0.85

	if slow_timer > 0.0:
		slow_timer -= delta
		if slow_timer <= 0.0:
			clear_slow()

	velocity *= speed_multiplier

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

func get_separation_force(neighbors: Array) -> Vector2:
	var force := Vector2.ZERO

	for other in neighbors:
		var diff = global_position - other.global_position
		var dist = diff.length()
	
		if dist > 0.0 and dist < separation_radius:
			var strength = 1.0 - (dist / separation_radius)
			force += diff.normalized() * strength

	return force * separation_strength


func reset_polarization():
	polarization_side = 0
	velocity = Vector2.ZERO


func freeze(duration: float):
	frozen = true
	frozen_timer = duration
	velocity = Vector2.ZERO
	sprite.modulate = Color(0.37, 0.0, 0.086, 1.0) # azulado
	
	
func unfreeze():
	frozen = false
	frozen_timer = 0.0
	sprite.modulate = Color.WHITE

func apply_slow(multiplier: float, duration: float):
	speed_multiplier = multiplier
	slow_timer = duration
	sprite.modulate = Color(0.8, 0.8, 0.8) # dessaturado

func clear_slow():
	speed_multiplier = 1.0
	slow_timer = 0.0
	sprite.modulate = Color.WHITE
