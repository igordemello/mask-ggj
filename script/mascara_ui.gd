extends AnimatedSprite2D

var animAtual: String = ""
@onready var mascara_ui: AnimatedSprite2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MaskController.current_mask == 1 and animAtual != "Populismo":
		mascara_ui.play("Populismo")
		animAtual = "Populismo"
	elif MaskController.current_mask == 2 and animAtual != "Polarização":
		mascara_ui.play("Polarização")
		animAtual = "Polarização"
	elif MaskController.current_mask == 3 and animAtual != "Bastidores":
		mascara_ui.play("Bastidores")
		animAtual = "Bastidores"
	elif MaskController.current_mask == 4 and animAtual != "Técnica":
		mascara_ui.play("Técnica")
		animAtual = "Técnica"
	elif MaskController.current_mask == 5 and animAtual != "DiscursoVazio":
		mascara_ui.play("DiscursoVazio")
		animAtual = "DiscursoVazio"
	else:
		mascara_ui.play("Default")
		animAtual = "Default"
	pass
