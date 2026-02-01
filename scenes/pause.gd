extends Control

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if  Input.is_action_just_pressed("ESC"):
		get_tree().paused = true
		visible = true
