extends Node2D

@export var player := CharacterBody2D

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name != "player":
		await get_tree().create_timer(0.75).timeout
		body.freeze(300)
		GameController.votos_atuais +=1
