extends Node2D

@export var player := CharacterBody2D

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == null:
		return
	
	if body.name == "player":
		return

	await get_tree().create_timer(0.75).timeout
	if not is_instance_valid(body):
		GameController.adicionar_voto(500)
		return

	body.freeze(10)
	flash_white(body)

	await get_tree().create_timer(0.75).timeout
	if not is_instance_valid(body):
		GameController.adicionar_voto(50)
		return

	body.queue_free()
	GameController.adicionar_voto(50)
		
func flash_white(body: Node2D):
	# Procuramos pelo AnimatedSprite2D no corpo que entrou na área
	var sprite = body.get_node_or_null("AnimatedSprite2D")
	
	if sprite and sprite.material:
		var flash_material = sprite.material
		flash_material.set_shader_parameter("flash_strength", 1.0)
		
		var tween := create_tween()
		tween.tween_property(flash_material, "shader_parameter/flash_strength", 0.0, 0.4)
