extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("entry_jornal")
	
	await animation_player.animation_finished
	
	$BotaoReiniciar.visible = true
	$BotaoMenu.visible = true


func _on_botao_reiniciar_pressed() -> void:
	MaskController.current_mask = 0
	GameController.etica = 100
	GameController.vidas = 3
	get_tree().change_scene_to_file("res://scenes/fase1.tscn")


func _on_botao_menu_pressed() -> void:
	MaskController.current_mask = 0
	GameController.etica = 100
	GameController.vidas = 3
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
