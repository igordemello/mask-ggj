extends Node2D

@export var cell_size := 64
@export var radius := 300

var cells := {}

func world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		int(pos.x / cell_size),
		int(pos.y / cell_size)
	)

func clear():
	cells.clear()

func add_density(world_pos: Vector2, amount := 1.0):
	var cell := world_to_cell(world_pos)
	if not cells.has(cell):
		cells[cell] = {
			"density": 0.0,
			"force": Vector2.ZERO
		}
	cells[cell]["density"] += amount
