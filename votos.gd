extends Control

# Arraste o nó do seu Label para cá segurando CTRL para criar a referência
@onready var label_votos = $label_votos # Use o nome exato da árvore de cenas
func _ready():
	# 1. Conecta o sinal do GameController a uma função local
	GameController.votos_alterados.connect(_on_votos_alterados)
	
	# 2. Define o texto inicial
	_atualizar_texto_votos(GameController.votos_atuais)

# Função que é chamada toda vez que o sinal 'votos_alterados' é disparado
func _on_votos_alterados(nova_qtd):
	_atualizar_texto_votos(nova_qtd)

func _atualizar_texto_votos(valor):
	# Substitui o texto usando formatação de String
	label_votos.text = str(valor) + " votos"
