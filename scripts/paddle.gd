@tool
class_name Paddle
extends CharacterBody2D

var collision_shape : RectangleShape2D
var color_rect : ColorRect

const SPEED = 500.0

var direction : float

@export var is_player : bool = false

func pause() -> void:
	set_process_input(false)
	set_physics_process(false)

func unpause() -> void:
	set_process_input(true)
	set_physics_process(true)

func _start_game() -> void:
	unpause()

func _ready() -> void:
	pause()
	collision_shape = $CollisionShape2D.shape
	color_rect = $ColorRect
	if Engine.is_editor_hint():
		collision_shape.changed.connect(func ():
			color_rect.size = collision_shape.size
			)
	else:
		get_owner().game_ready.connect(_on_game_ready)
		EventBus.game_paused.connect(pause)
		EventBus.game_unpaused.connect(unpause)

func _on_game_ready() -> void:
	_start_game()

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	#if InputActions.is_any_released(event, [InputActions.MOVE_LEFT,
	#InputActions.MOVE_RIGHT]):
		#velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	direction = Input.get_axis(InputActions.MOVE_LEFT, InputActions.MOVE_RIGHT)
	
	const accel = 500.0
	
	if direction:
		var desired_velocity := direction * SPEED
		velocity.x = move_toward(velocity.x, desired_velocity, delta * accel)
	elif not direction and not is_zero_approx(velocity.x):
		velocity = velocity.move_toward(Vector2.ZERO, delta * accel)
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		pass # this works as expected
