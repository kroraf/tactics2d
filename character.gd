extends Area2D
class_name Character

var in_motion = false

var map_position: Vector2i:
	get:
		return Navigation.global_to_map(global_position)

func move_along_path(path: Array) -> void:
	if not in_motion:
		for cell in path:
			in_motion = true
			var tween = create_tween()
			tween.tween_property(self, 'global_position', Navigation.map_to_global(cell), 0.2)
			tween.connect("finished", _on_tween_finished)
			await tween.finished

func _on_tween_finished() -> void:
	in_motion = false
