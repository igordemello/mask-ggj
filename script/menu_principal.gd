extends Control

	
# Função que roda quando clicamos no botão de jogar
func _on_botao_jogar_pressed():
	# Isso carrega a sua cena que aparece no print!
	get_tree().change_scene_to_file("res://scenes/main.tscn") 

# Função que roda quando clicamos em sair
func _on_botao_sair_pressed():
	get_tree().quit()
