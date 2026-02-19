class_name Hazard
extends Area2D

@export var knockback_strength: float = 400.0

@onready var hit_sound: AudioStreamPlayer2D = %HitSound


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.has_method('apply_knockback'):
		hit_sound.play()
		body.apply_knockback(global_position, knockback_strength)
