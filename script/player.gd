extends CharacterBody2D

const SPEED = 300.0
const ACELL = 2.0
const ROTATION_SPEED := 8.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var flash_material: ShaderMaterial = sprite.material
@onready var crowd_system := get_parent().get_node("CrowdSystem")
@onready var som_dano: AudioStreamPlayer2D = $SomDano
@onready var som_andar: AudioStreamPlayer2D = $SomAndar

var input: Vector2
var is_playing_priority_anim := false 
var can_take_damage := true

var menu_ui_scene = preload("res://scenes/menuMascaras.tscn")
var menu_instancia: CanvasLayer

@export var invincibility_time := 0.5

signal damaged

func _ready() -> void:
	MaskController.mask_changed.connect(crowd_system.set_mask)
	MaskController.mask_changed.connect(_on_mask_changed)
	
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

func _physics_process(delta: float):
	var playerInput = get_input() 
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACELL)
	move_and_slide()
	
	if not is_playing_priority_anim:
		if velocity.length() > 2.0:
			# Lógica da Animação
			if sprite.animation != "run":
				sprite.play("run")
			
			# Lógica do Som de Passos
			if not som_andar.playing:
				som_andar.play()
		else:
			# Lógica da Animação
			if sprite.animation != "idle":
				sprite.play("idle")
			
			# Para o som imediatamente ao ficar idle
			if som_andar.playing:
				som_andar.stop()

	if velocity.length() > 5.0:
		var target_rotation := velocity.angle() + PI / 2
		sprite.rotation = lerp_angle(
			sprite.rotation,
			target_rotation,
			delta * ROTATION_SPEED
		)

func _on_mask_changed(_mask_id: int):
	is_playing_priority_anim = true
	
	sprite.frame = 0
	sprite.play("mask")
	flash_white()
	
	if not sprite.animation_finished.is_connected(_on_priority_anim_finished):
		sprite.animation_finished.connect(_on_priority_anim_finished, CONNECT_ONE_SHOT)
	
	if not sprite.animation_finished.is_connected(_on_priority_anim_finished):
		sprite.animation_finished.connect(_on_priority_anim_finished, CONNECT_ONE_SHOT)

func _on_priority_anim_finished():
	is_playing_priority_anim = false

func take_damage():
	if not can_take_damage:
		return

	GameController.vidas -= 1
	flash_white()
	som_dano.play()
	
	if GameController.vidas <= 0:
		GameController.morrer("vida_0") 
		return

	can_take_damage = false
	emit_signal("damaged")

	await get_tree().create_timer(invincibility_time).timeout
	can_take_damage = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is CharacterBody2D:
		take_damage()

func flash_white():
	if flash_material:
		flash_material.set_shader_parameter("flash_strength", 1.0)
		var tween := create_tween()
		tween.tween_property(flash_material, "shader_parameter/flash_strength", 0.0, 0.4)

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
