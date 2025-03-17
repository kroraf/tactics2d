extends Node2D

@onready var mouse_highlight: Sprite2D = $mouse_highlight
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var character: Character = $Character

var astar: AStarGrid2D = AStarGrid2D.new()
var snapped_position = Vector2.ZERO
var global_mouse_position
var map_mouse_position
var character_destination: Vector2i

func _ready() -> void:
	Navigation.init(tile_map_layer)

func _process(_delta: float) -> void:
	global_mouse_position = get_global_mouse_position()
	map_mouse_position = local_to_map(global_mouse_position)
	if map_mouse_position in tile_map_layer.get_used_cells():
		mouse_highlight.global_position = map_to_local(map_mouse_position)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var click_global_position = map_to_local(local_to_map(get_local_mouse_position()))
			if local_to_map(click_global_position) in tile_map_layer.get_used_cells():
				var path = Navigation.get_movement_path(character.map_position, map_mouse_position)
				character.move_along_path(path)


func map_to_local(map_position):
	return tile_map_layer.map_to_local(map_position)
	
func local_to_map(local_position):
	return tile_map_layer.local_to_map(local_position)
