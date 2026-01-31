extends Node2D

@export var enemy_prefab : PackedScene
@export var target : Node2D


func _on_timer_timeout() -> void:
	var enemy = enemy_prefab.instantiate()
	enemy.player = target
	add_child(enemy)
