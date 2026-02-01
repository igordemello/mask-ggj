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

var qtd_uso := {
	"Populismo": 0,
	"Polarizacao": 0,
	"Bastidores": 0,
	"Tecnica": 0,
	"DiscursoVazio": 0
}

var titulos_manchetes_finais := {
	"Populismo": ["A VITÓRIA DO VAZIO","No aniversário da posse, o governo que prometia estabilidade técnica assiste à derrocada da moeda; desabastecimento severo e preços proibitivos transformam o cotidiano de milhões em uma luta desesperada pela sobrevivência."],
	"Polarizacao": ["NAÇÃO PARTIDA","Enquanto facções ocupam as principais capitais, analistas e historiadores são unânimes: o colapso da ordem é o resultado direto de uma política que transformou cidadãos em inimigos estatísticos."],
	"Bastidores": ["QUEDA NO SISTEMA","Após meses de investigações, são divulgadas provas de acordos ilícitos com o mercado privado, Hasto sofre impeachment"],
	"Tecnica": ["O PREÇO DA ORDEM","Enquanto os índices macroeconômicos brilham, a lacuna social atinge níveis críticos."],
	"DiscursoVazio": ["A VOLTA AO MAPA DA FOME","Após série de tratados comerciais prejudiciais e políticas internas equivocadas, órgãos internacionais confirmam o colapso da segurança alimentar; especialistas classificam governo como tecnocracia da incompetência."]
}

func get_most_used_mask() -> String:
	var max_key := ""
	var max_value := -1

	for key in qtd_uso.keys():
		if qtd_uso[key] > max_value:
			max_value = qtd_uso[key]
			max_key = key

	return max_key

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
	etica = etica - qtd
	emit_signal("etica_alterada", etica)
	
	# Condição de Derrota 2: Ética chega a 0
	if etica <= 0:
		morrer("Desmascarado!", "Após tentar subornar até o próprio reflexo, Hasto cai em desonra pública. Eleitores sugerem que ele tente a sorte como síndico de presídio.")

func etica_recuperar(qtd: float):
	etica = min(100, etica + qtd)
	emit_signal("etica_alterada", etica)
	

func morrer(titulo: String, desc: String):
	jornal_titulo = titulo
	jornal_descricao = desc
	#get_tree().paused = true
	# call_deferred é mais seguro para mudar de cena durante colisões
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mesa_derrota.tscn")
	
func ganhar():
	var mask = get_most_used_mask()
	
	if not titulos_manchetes_finais.has(mask):
		push_warning("Máscara sem manchete: " + mask)
		return

	var titulo = titulos_manchetes_finais[mask][0]
	var desc = titulos_manchetes_finais[mask][1]
	
	jornal_titulo = titulo
	jornal_descricao = desc
	#get_tree().paused = true
	# call_deferred é mais seguro para mudar de cena durante colisões
	get_tree().call_deferred("change_scene_to_file", "res://scenes/mesa_vitória.tscn")
