extends Area2D

@export var speed := 600.0
@export var lifetime := 2.0
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
	if body == null:
		return
	if body.name == "player":
		return
	if not body.is_in_group("agents"):
		return

	var agent = body

	await get_tree().create_timer(0.75).timeout
	if not is_instance_valid(agent):
		return

	agent.freeze(3)
	flash_white(agent)

	#await get_tree().create_timer(0.75).timeout
	if not is_instance_valid(agent):
		return

	agent.queue_free()
	GameController.adicionar_voto(50)
	
	queue_free()
	
func flash_white(body: Node2D):
	# Procuramos pelo AnimatedSprite2D no corpo que entrou na área
	var sprite = body.get_node_or_null("AnimatedSprite2D")
	
	if sprite and sprite.material:
		var flash_material = sprite.material
		flash_material.set_shader_parameter("flash_strength", 1.0)
		
		var tween := create_tween()
		tween.tween_property(flash_material, "shader_parameter/flash_strength", 0.0, 0.4)
