extends Node

var vidas: int = 3 # se chegar a zero é aquela derrota
var etica: float = 100
var votos: float = 0.5

signal etica_alterada(value)

func etica_gastar(qtd: float):
	etica = max(0, etica - qtd)
	emit_signal("etica_alterada", etica)

func etica_recuperar(qtd: float):
	etica = min(100, etica + qtd)
	emit_signal("etica_alterada", etica)
	
func etica_pode_gastar(qtd) -> bool:
	return etica >= qtd
