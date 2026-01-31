extends CharacterBody2D

const SPEED = 300.0
const ACELL = 2.0
const ROTATION_SPEED := 8.0

var input: Vector2

@onready var sprite: AnimatedSprite2D = $sprite
@onready var flash_material: ShaderMaterial = sprite.material

@export var invincibility_time := 0.5
var can_take_damage := true

@onready var crowd_system := get_parent().get_node("CrowdSystem")

signal damaged

func _ready() -> void:
	MaskController.mask_changed.connect(
		crowd_system.set_mask
	)


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


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mask_populismo"):
		MaskController.equip_mask(MaskController.MaskType.POPULISMO)

	if Input.is_action_just_pressed("mask_polarizacao"):
		MaskController.equip_mask(MaskController.MaskType.POLARIZACAO)

	if Input.is_action_just_pressed("mask_tecnica"):
		MaskController.equip_mask(MaskController.MaskType.TECNICA)

func take_damage():
	if not can_take_damage:
		return

	if GameController.vidas == 0:
		print("morreu saporra")
		return

	GameController.vidas -= 1
	flash_white()
	print("Player tomou dano -1 coração")

	can_take_damage = false
	emit_signal("damaged")

	

	await get_tree().create_timer(invincibility_time).timeout
	can_take_damage = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is CharacterBody2D:
		take_damage()


func flash_white():
	flash_material.set_shader_parameter("flash_strength", 1.0)

	var tween := create_tween()
	tween.tween_property(
		flash_material,
		"shader_parameter/flash_strength",
		0.0,
		0.4
	)
