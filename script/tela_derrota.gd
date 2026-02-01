extends Control

@onready var som_morte1: AudioStreamPlayer2D = $SomMorte1
@onready var som_morte2: AudioStreamPlayer2D = $SomMorte2

func _ready():
	# Garante que o jogo não esteja pausado para os botões funcionarem
	get_tree().paused = false
	# Foca no botão de reiniciar para facilitar o uso de teclado/controle
	$VBoxContainer/BotaoReiniciar.grab_focus()
	som_morte1.play()
	som_morte2.play()
	

func _on_botao_reiniciar_pressed():
	# Reseta os status antes de carregar
	GameController.vidas = 3
	GameController.etica = 100.0
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_botao_menu_pressed():
	# Volta para a cena do Menu Principal que criamos antes
	GameController.vidas = 3
	GameController.etica = 100.0
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
