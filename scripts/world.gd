extends Node2D


@onready var mouse_highlight: Sprite2D = $mouse_highlight
@onready var ground_layer: TileMapLayer = $Map/GroundLayer
@onready var rock_layer = $Map/RockLayer
@onready var unit = $UnitManager/Player/Unit
@onready var unit_2 = $UnitManager/Enemy/Unit2
@onready var unit_manager = $UnitManager

@onready var coordinates_label = $Camera2D/CoordinatesLabel
@onready var movement_overlay: MovementOverlay = $Map/MovementOverlay
@onready var turn_indicator = $Camera2D/TurnIndicator
@onready var current_unit: Unit

var _walkable_cells: Array = []

var astar: AStarGrid2D = AStarGrid2D.new()
var snapped_position = Vector2.ZERO

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]


func _ready() -> void:
	Navigation.init([ground_layer, rock_layer])
	EventBus.cursor_accept_pressed.connect(_on_cursor_accept_pressed)
	EventBus.show_movement_field.connect(_on_show_movement_field)
	unit_manager.start_battle()


func move_unit_to_cell(unit: Unit, coordinates: Vector2i) -> void:
	var entity = unit
	if coordinates in ground_layer.get_used_cells():
		movement_overlay.clear()
		var path: Array = Navigation.get_movement_path(unit.cell_position, coordinates)
		entity.move_along_path(path)
		entity.decrease_ap(path.size()-1)
		await entity.movement_complete
		_update_movement_data(entity)

func verify_and_move_current_unit(clicked_cell: Vector2i) -> void:
	current_unit = unit_manager.get_current_unit()
	if clicked_cell in _walkable_cells:
		move_unit_to_cell(current_unit, clicked_cell)
	else:
		pass
		'''TODO: action-not-valid sound'''

func _flood_fill(cell: Vector2i, max_distance: int) -> Array:
	var valid_cells := []
	var stack := [cell]
	while not stack.size() == 0:
		var current: Vector2i = stack.pop_back()
		if current not in Navigation.map.get_used_cells():
			continue
		if current in valid_cells:
			continue

		var distance = Navigation.get_movement_path(current, cell).size() - 1
		if distance > max_distance:
			continue
		if not current == cell:
			valid_cells.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2i = current + direction
			if Navigation.is_cell_solid(coordinates):
				continue
			if coordinates in valid_cells:
				continue
			if coordinates in stack:
				continue

			stack.append(coordinates)
	return valid_cells
	
func _get_movement_cells(entity: Unit) -> Array:
	return _flood_fill(entity.cell_position, entity.current_ap)
	
func _update_movement_data(unit: Unit) -> void:
	_walkable_cells = _get_movement_cells(unit)
	movement_overlay.draw(_walkable_cells)

func _on_cursor_accept_pressed(cursor_cell):
	coordinates_label.text = str(cursor_cell)
	verify_and_move_current_unit(cursor_cell)

func _on_cursor_moved(cursor_cell):
	if cursor_cell in ground_layer.get_used_cells():
		if not Navigation.is_cell_solid(cursor_cell):
			if cursor_cell in _walkable_cells:
				pass
			mouse_highlight.show()
			mouse_highlight.global_position = Navigation.map_to_global(cursor_cell)
		else:
			mouse_highlight.hide()
	else:
		mouse_highlight.hide()

func _on_end_turn_pressed():
	print("end turn")
	unit_manager._step_turn()
	
func _on_show_movement_field(unit):
	_update_movement_data(unit)
	
func update_current_unit():
	current_unit = unit_manager.get_current_unit()
