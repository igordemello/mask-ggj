extends Node2D

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _process(delta: float) -> void:
	texture_progress_bar.value = GameController.etica
