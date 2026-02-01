extends CharacterBody2D

const SPEED = 300.0
const ACELL = 2.0
const ROTATION_SPEED := 8.0

var input: Vector2

@onready var sprite: AnimatedSprite2D = $sprite
@onready var flash_material: ShaderMaterial = sprite.material

var menu_ui_scene = preload("res://scenes/menuMascaras.tscn")
var menu_instancia: CanvasLayer

@export var invincibility_time := 0.5
var can_take_damage := true

@onready var crowd_system := get_parent().get_node("CrowdSystem")

signal damaged

func _ready() -> void:
	MaskController.mask_changed.connect(
		crowd_system.set_mask
	)
	if menu_ui_scene:
		menu_instancia = menu_ui_scene.instantiate()
		get_tree().root.add_child.call_deferred(menu_instancia)
		menu_instancia.visible = false

func _input(event):
	if event.is_action_pressed("mask_UI"):
		abrir_menu()
	if event.is_action_released("mask_UI"):
		fechar_menu()

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

	# Reduz a vida no controlador global
	GameController.vidas -= 1
	flash_white()
	print("Player tomou dano. Vidas: ", GameController.vidas)

	# Verifica se morreu
	if GameController.vidas <= 0:
		print("Morreu saporra")
		# Chama a função de morrer que vamos criar no GameController
		GameController.morrer("vida_0") 
		return

	can_take_damage = false
	emit_signal("damaged")

	await get_tree().create_timer(invincibility_time).timeout
	can_take_damage = true

	

	await get_tree().create_timer(invincibility_time).timeout
	can_take_damage = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is CharacterBody2D:
		take_damage()

func abrir_menu():
	if menu_instancia:
		menu_instancia.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Engine.time_scale = 0.1
		
func fechar_menu():
	if menu_instancia:
		menu_instancia.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Engine.time_scale = 1.0

func flash_white():
	flash_material.set_shader_parameter("flash_strength", 1.0)

	var tween := create_tween()
	tween.tween_property(
		flash_material,
		"shader_parameter/flash_strength",
		0.0,
		0.4
	)

func _on_button_sair_pressed() -> void:
	pass # Replace with function body.
