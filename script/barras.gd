extends Control

@onready var martelo_1: AnimatedSprite2D = $martelo_1
@onready var martelo_2: AnimatedSprite2D = $martelo_2
@onready var martelo_3: AnimatedSprite2D = $martelo_3

func _process(delta: float) -> void:
	if GameController.vidas == 3:
		martelo_1.play("martelo_levantado")
		martelo_2.play("martelo_levantado")
		martelo_3.play("martelo_levantado")
	elif GameController.vidas == 2:
		martelo_1.play("martelo_levantado")
		martelo_2.play("martelo_levantado")
		martelo_3.play("martelo_batido")
	elif GameController.vidas == 1:
		martelo_1.play("martelo_levantado")
		martelo_2.play("martelo_batido")
		martelo_3.play("martelo_batido")
	elif GameController.vidas < 1:
		martelo_1.play("martelo_batido")
		martelo_2.play("martelo_batido")
		martelo_3.play("martelo_batido")
