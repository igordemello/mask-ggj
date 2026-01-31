extends Node2D

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

@onready var barra_cima: AnimatedSprite2D = $barra_cima

var animacao_atual := ""

func _process(delta: float) -> void:
	texture_progress_bar.value = GameController.etica
	_atualizar_barra_cima()
	
func _atualizar_barra_cima() -> void:
	var nova_animacao: String

	if GameController.etica > 75:
		nova_animacao = "boa"
	elif GameController.etica >= 25:
		nova_animacao = "neutra"
	else:
		nova_animacao = "ruim"

	if animacao_atual != nova_animacao:
		animacao_atual = nova_animacao
		barra_cima.play(animacao_atual)
