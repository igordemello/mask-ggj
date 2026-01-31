extends Control

var cores_hover = {
	"Area2D": Color(1, 0, 0, 0.5),
	"Area2D2": Color(0, 1, 0, 0.5),
	"Area2D3": Color(0, 0, 1, 0.5),
	"Area2D4": Color(1, 1, 0, 0.5),
	"Area2D5": Color(1, 0, 1, 0.5)
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
	if poly and cores_hover.has(area_node.name):
		poly.color = cores_hover[area_node.name]

func _on_area_mouse_exited(area_node):
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	var poly = area_node.get_node_or_null("Polygon2D")
	if poly:
		poly.color = Color(0.659, 0.659, 0.659, 0.996)
func executar_acao(nome_do_botao):
	match nome_do_botao:
		"Area2D":
			print("Ação 1")
		"Area2D2":
			print("Ação 2")
		"Area2D3":
			print("Ação 3")
		"Area2D4":
			print("Ação 4")
		"Area2D5":
			print("Ação 5")
