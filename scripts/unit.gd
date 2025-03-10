extends Area2D
class_name Unit

@export var stats: UnitStats
@onready var animation_player = $AnimationPlayer


var max_ap: int
var current_ap: int
var hp: int
var in_motion = false
var cell_position: Vector2i = Vector2i.ZERO:
	get:
		return Navigation.global_to_map(global_position)
	set(cell):
		global_position = Navigation.map_to_global(cell)
		
signal movement_complete
		
func _ready():
	max_ap = stats.max_ap
	current_ap = max_ap
	hp = stats.hp
	animation_player.add_animation_library("player_animation_library", load("res://player_animation_library.res"))
	animation_player.play("player_animation_library/idle_front")

func move_along_path(path: Array) -> void:
	if not in_motion:
		for cell in path:
			in_motion = true
			#animation_tree.set("parameters/blend_position", Navigation.map_to_global(cell_position).direction_to(Navigation.map_to_global(cell)))
			var move_tween = create_tween()
			move_tween.tween_property(self, 'global_position', Navigation.map_to_global(cell), 0.2)
			move_tween.connect("finished", _on_move_tween_finished)
			await move_tween.finished
		movement_complete.emit()

func _on_move_tween_finished() -> void:
	in_motion = false
	
func decrease_ap(value):
	current_ap -= value
	
func reset_ap():
	current_ap = max_ap
