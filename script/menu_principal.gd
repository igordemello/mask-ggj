extends Control

func _ready():
	# Substitua 'BotaoJogar' pelo nome exato do seu nó no menu
	$VBoxContainer/BotaoJogar.grab_focus()
	
# Função que roda quando clicamos no botão de jogar
func _on_botao_jogar_pressed():
	# Isso carrega a sua cena que aparece no print!
	get_tree().change_scene_to_file("res://scenes/main.tscn") 

# Função que roda quando clicamos em sair
func _on_botao_sair_pressed():
	get_tree().quit()

func _on_button_pressed() -> void:
	pass # Replace with function body.
