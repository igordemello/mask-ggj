extends Control

@onready var gov_para_qm: Sprite2D = $GovParaQm
@onready var som_cochichos: AudioStreamPlayer2D = $Cochichos
@onready var som_martelo: AudioStreamPlayer2D = $Martelo

func _ready() -> void:
	gov_para_qm.modulate.a = 0.0
	som_cochichos.play()

func _on_botao_jogar_pressed() -> void:
	var tween := create_tween()
	som_martelo.play()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		gov_para_qm,
		"modulate:a",
		1.0,
		0.8
	)

	await tween.finished

	await get_tree().create_timer(3.0).timeout

	get_tree().change_scene_to_file("res://scenes/fase1.tscn")

func _on_botao_sair_pressed() -> void:
	get_tree().quit()
