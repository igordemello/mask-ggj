extends Node

var vidas: int = 3 # se chegar a zero é aquela derrota
var etica: float = 100
var votos: float = 0.5
var causa_da_morte : String = "" # Para saber qual manchete mostrar

signal etica_alterada(value)

func etica_gastar(qtd: float):
	etica = max(0, etica - qtd)
	emit_signal("etica_alterada", etica)
	
	# Condição de Derrota 2: Ética chega a 0
	if etica <= 0:
		morrer("etica")

func etica_recuperar(qtd: float):
	etica = min(100, etica + qtd)
	emit_signal("etica_alterada", etica)
	
func etica_pode_gastar(qtd) -> bool:
	return etica >= qtd

func morrer(motivo: String):
	causa_da_morte = motivo
	get_tree().paused = true
	# call_deferred é mais seguro para mudar de cena durante colisões
	get_tree().call_deferred("change_scene_to_file", "res://scenes/telaDerrota.tscn")
