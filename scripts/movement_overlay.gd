extends TileMapLayer
class_name MovementOverlay

func draw(cells: Array) -> void:
	clear()
	for cell in cells:
		set_cell(cell, 0, Vector2i(0, 0))
