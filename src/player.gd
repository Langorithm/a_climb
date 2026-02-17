class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER = 0.1
const FALL_GRAVITY_MULT = 2.0
const LOW_JUMP_MULT = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0.0
var jump_buffer_timer = 0.0


func _physics_process(delta):
	var current_gravity = gravity

	if velocity.y > 0:
		current_gravity *= FALL_GRAVITY_MULT

	elif velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
		current_gravity *= LOW_JUMP_MULT

	if not is_on_floor():
		velocity.y += current_gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER

	jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
