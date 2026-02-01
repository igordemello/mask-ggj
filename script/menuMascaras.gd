extends Control

var cores_hover = {
	"Area2D": Color(1, 0, 0, 0.2),
	"Area2D2": Color(0, 1, 0, 0.2),
	"Area2D3": Color(0, 0, 1, 0.2),
	"Area2D4": Color(1, 1, 0, 0.2),
	"Area2D5": Color(1, 0, 1, 0.2)
}

var positionDesc = {
	"Area2D": Vector2(365, 890),
	"Area2D2": Vector2(1160, 890),
	"Area2D3": Vector2(1450, 470),
	"Area2D4": Vector2(1080, 80),
	"Area2D5": Vector2(95, 465)
}

var textDesc = {
	"Area2D": "Ótimo a curto prazo, desacelera a multidão",
	"Area2D2": "Divide a massa em dois grupos, forçando-os a se reagrupar novamente",
	"Area2D3": "Destinada a tudo que precisa ficar pelas sombras. Remove inimigos silenciosamente.",
	"Area2D4": "Empurra a massa para trás com discurso barato",
	"Area2D5": "Para aquele que governa dados e não pessoas. Paralisa 50% do enxame"
}

var textTitle = {
	"Area2D": "Discurso Vazio",
	"Area2D2": "Polarização",
	"Area2D3": "Bastidores",
	"Area2D4": "Populismo",
	"Area2D5": "Técnica"
}

func _ready():
	for child in get_children():
		if child is Area2D:
			child.input_event.connect(_on_area_input_event.bind(child))
			child.mouse_entered.connect(_on_area_mouse_entered.bind(child))
			child.mouse_exited.connect(_on_area_mouse_exited.bind(child))

func _on_area_input_event(viewport, event, shape_idx, area_node):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		executar_acao(area_node.name)

func _on_area_mouse_entered(area_node):
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	var poly = area_node.get_node_or_null("Polygon2D")
	var mask = area_node.get_node_or_null("Sprite2D")
	if poly and cores_hover.has(area_node.name):
		poly.color = cores_hover[area_node.name]
		$caixaDeInfo.position = positionDesc[area_node.name]
		$caixaDeInfo.show()
		var tween = create_tween()
		$caixaDeInfo.scale = Vector2(0.5, 0.5)
		tween.tween_property($caixaDeInfo, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		$caixaDeInfo/desc.text = textDesc[area_node.name]
		$caixaDeInfo/title.text = textTitle[area_node.name]
		mask.scale = Vector2(lerp(5.0, 7.5, 0.6), lerp(5.0, 7.5, 0.6))
		
func _on_area_mouse_exited(area_node):
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	var poly = area_node.get_node_or_null("Polygon2D")
	var mask = area_node.get_node_or_null("Sprite2D")
	if poly and mask:
		poly.color = Color(0.659, 0.659, 0.659, 0.2)
		mask.scale = Vector2(5, 5)

func executar_acao(nome_do_botao):
	match nome_do_botao:
		"Area2D":
			MaskController.equip_mask(5)
		"Area2D2":
			MaskController.equip_mask(2)
		"Area2D3":
			MaskController.equip_mask(3)
		"Area2D4":
			MaskController.equip_mask(1)
		"Area2D5":
			MaskController.equip_mask(4)
