extends Node

@export var ethics_cost := 5
@export var ethics_recover_rate := 1.0
signal mask_changed(mask: int)

enum MaskType {
	NONE,
	POPULISMO,
	POLARIZACAO,
	BASTIDORES,
	TECNICA,
	DISCURSO_VAZIO
}

var current_mask := MaskType.NONE
var ethics_timer := 0.0



func equip_mask(mask: int):
	if current_mask == mask:
		return

	GameController.etica_gastar(ethics_cost)
	current_mask = mask
	
	emit_signal("mask_changed", mask)
	
	
func _process(delta):
	if current_mask != MaskType.NONE:
		ethics_timer += delta
		if ethics_timer >= 1.0:
			GameController.etica_recuperar(ethics_recover_rate)
			ethics_timer = 0
