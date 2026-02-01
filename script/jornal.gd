extends Node2D

@onready var titulo: Label = $titulo
@onready var descricao: Label = $descricao

func _ready() -> void:
	titulo.text = GameController.jornal_titulo
	descricao.text = GameController.jornal_descricao
