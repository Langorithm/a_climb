extends Node2D

@onready var win_area: Area2D = %WinArea
@onready var win_label: Label = %WinLabel
@onready var black_screen: ColorRect = %BlackScreen
@onready var win_sound: AudioStreamPlayer = %WinSound


func _ready() -> void:
	win_area.body_entered.connect(_on_winarea_body_entered)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_winarea_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		win_sound.play()
		var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ignore_time_scale(true)
		t.tween_property(Engine, "time_scale", 0.1, .5)

		t.parallel().tween_property(
			win_label,
			"self_modulate",
			Color.WHITE,
			1.0,
		)
		t.tween_interval(1.3)
		t.tween_property(
			black_screen,
			"color:a",
			1.0,
			1.5,
		)
		t.tween_interval(1.0)
		await t.finished
		Engine.time_scale = 1.0
		get_tree().quit()
