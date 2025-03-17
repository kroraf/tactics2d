extends Node

var grid: AStarGrid2D
var map: TileMapLayer

func init(tile_maps: Array) -> void:
	map = tile_maps[0]
	grid = AStarGrid2D.new()
	grid.region = map.get_used_rect()
	print(map.get_used_rect())
	grid.cell_size = map.tile_set.tile_size
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()
	
	for cell_coords in map.get_used_cells():
		var cell_data = map.get_cell_tile_data(cell_coords)
		grid.set_point_solid(cell_coords, cell_data.get_custom_data("is_solid"))
	
func map_to_global(map_position) -> Vector2:
	return map.map_to_local(map_position)
	
func global_to_map(global_position: Vector2) -> Vector2i:
	return map.local_to_map(global_position)

func get_movement_path(start: Vector2i, destination: Vector2i) -> Array:
	return grid.get_id_path(start, destination)
