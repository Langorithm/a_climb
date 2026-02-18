class_name Platform
extends AnimatableBody2D

@onready var path: Line2D = $Line2D


func _ready() -> void:
	if path:
		path.visible = false
		var tween = create_tween().set_trans(
			Tween.TRANS_QUAD,
		).set_ease(Tween.EASE_IN_OUT).set_loops()
		_interpolate_path(tween, path.points)
		var backwards_path = path.points.duplicate()
		backwards_path.reverse()
		_interpolate_path(tween, backwards_path)

		# tween.tween_property(global_position


func _interpolate_path(tween: Tween, points: Array[Vector2]) -> void:
	for point in points:
		var point_pos := path.global_position + point
		tween.tween_property(self, "global_position", point_pos, 1.0)
