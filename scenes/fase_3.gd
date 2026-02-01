extends Node2D


@onready var crowd_system: Node2D = $CrowdSystem


func _process(delta: float) -> void:
	if not crowd_system.has_agents_alive():
		get_tree().change_scene_to_file("res://scenes/fase4.tscn")
