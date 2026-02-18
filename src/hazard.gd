class_name Hazard
extends Area2D

@export var knockback_strength: float = 400.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.has_method('apply_knockback'):
		body.apply_knockback(global_position, knockback_strength)
