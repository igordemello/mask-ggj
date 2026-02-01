extends Control

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ESC"):
		GameController.pausado = !GameController.pausado
		get_tree().paused = GameController.pausado
		visible = GameController.pausado


func _on_button_button_down() -> void:
	GameController.pausado = false
	get_tree().paused = false
	visible = false
