extends Camera2D

func shake(intensity: float, duration: float) -> void:
	var shakes = 20
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	for i in range(shakes):
		tween.tween_property(
			self,
			"offset",
			Vector2(
				randf_range(-intensity, intensity),
				randf_range(-intensity, intensity),
			),
			duration / shakes,
		)

	tween.tween_property(self, "offset", Vector2.ZERO, duration / shakes)


func _on_player_player_damaged() -> void:
	shake(12, .13)
