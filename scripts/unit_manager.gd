extends Node2D
class_name UnitManager

var groups: Array = []
var current_group: Node
var current_unit: Unit
var has_moved: bool = false
var current_unit_index: int = 0
var current_group_index: int = 0

func _ready() -> void:
	EventBus.end_turn.connect(_on_end_turn)
	for child in get_children():
		if child.get_child_count() > 0:
			groups.append(child)

func start_battle() -> void:
	current_group = groups[0]
	_begin_turn()
	
#iterates over units and groups. the values are then used in other functions
func _step_turn() -> void:
	var prev_index = current_unit_index
	var next_unit: Unit
	
	current_unit_index += 1
	if current_unit_index >= current_group.get_child_count():
		current_group_index = wrapi(current_group_index + 1, 0, groups.size())
		current_group = groups[current_group_index]
		current_unit_index = 0
		print("group switch to: ", current_group.name)
	_begin_turn()
	
func _begin_turn() -> void:
	current_unit = current_group.get_child(current_unit_index)
	current_unit.reset_ap()
	print("current unit ", current_unit_index, " from ", current_group.name)
	has_moved = false
	_update_movement_field()

func _update_movement_field() -> void:
	EventBus.show_movement_field.emit(current_unit)

func _on_end_turn():
	print("turn finished")
	_step_turn()
	
func get_current_unit():
	return current_unit
