extends Node

var vidas: int = 3 # se chegar a zero é aquela derrota
var etica: float = 100
var causa_da_morte : String = "" # Para saber qual manchete mostrar

signal etica_alterada(value)


var votos_atuais : int = 0
signal votos_alterados(nova_qtd) # Avisa quando a quantidade muda

var pausado := false

var jornal_titulo := ""
var jornal_descricao := ""

func adicionar_voto(qtd: int):
	votos_atuais += qtd
	votos_alterados.emit(votos_atuais)
	checaVitoria()
	
func checaVitoria():
	if votos_atuais >= 10000:
		vencer()
		
func vencer():
	print("Passou de fase")
	pass

func etica_gastar(qtd: float):
	etica = max(0, etica - qtd)
	emit_signal("etica_alterada", etica)
	
	# Condição de Derrota 2: Ética chega a 0
	if etica <= 0:
		morrer("Desmascarado!", "Após tentar subornar até o próprio reflexo, Hasto cai em desonra pública. Eleitores sugerem que ele tente a sorte como síndico de presídio.")

func etica_recuperar(qtd: float):
	etica = min(100, etica + qtd)
	emit_signal("etica_alterada", etica)
	
func etica_pode_gastar(qtd) -> bool:
	return etica >= qtd

func morrer(titulo: String, desc: String):
	jornal_titulo = titulo
	jornal_descricao = desc
	#get_tree().paused = true
	# call_deferred é mais seguro para mudar de cena durante colisões
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mesa_derrota.tscn")
