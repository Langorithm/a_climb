class_name Player
extends CharacterBody2D

signal player_damaged

const SPEED = 300.0
const JUMP_VELOCITY = 680.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER = 0.1
const FALL_GRAVITY_MULT = 2.0
const LOW_JUMP_MULT = 3.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var stun_duration = 0.35

var _knockback := Vector2.ZERO
var _stun_timer := 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	var current_gravity = gravity

	_stun_timer -= delta
	_stun_timer = max(0, _stun_timer)

	if velocity.y > 0:
		current_gravity *= FALL_GRAVITY_MULT
		if sprite.animation != "jump_fall":
			sprite.play("jump_fall")

	elif velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
		current_gravity *= LOW_JUMP_MULT

	if not is_on_floor():
		velocity.y += current_gravity * delta
		coyote_timer -= delta
	else:
		if sprite.animation != "idle" and Input.get_axis("ui_left", "ui_right") == 0:
			sprite.play("idle")
		coyote_timer = COYOTE_TIME

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER
		sprite.play("jump_rise")

	jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = -JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5

	if _stun_timer <= 0:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			sprite.flip_h = direction < 0
			if sprite.animation not in ["run", 'jump_rise'] and is_on_floor():
				sprite.play("run")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity += _knockback
	_knockback = _knockback.move_toward(Vector2.ZERO, 1000 * delta)
	apply_floor_snap()
	move_and_slide()


func apply_knockback(hazard_position: Vector2, strength: float):
	player_damaged.emit()
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(self, 'modulate', Color.CRIMSON, .01)
	t.tween_property(self, 'modulate', Color.WHITE, stun_duration + 6)
	var dir = global_position.x - hazard_position.x
	dir = sign(dir) # Returns -1 or 1
	_stun_timer = stun_duration

	# Apply horizontal force
	_knockback.x = dir * strength

	# Apply a small vertical 'pop' so they leave the ground
	velocity.y = -strength
