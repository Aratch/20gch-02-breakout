@tool
class_name Paddle
extends CharacterBody2D

var collision_shape : RectangleShape2D
var color_rect : ColorRect

const SPEED = 300.0

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
	var window_size := DisplayServer.window_get_size()
	position.y = window_size.y / 2.0
	var ratio = 7.0
	if is_player:
		position.x = window_size.x / ratio
	else:
		position.x = (ratio - 1) * (window_size.x / ratio)

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

func _on_game_ready() -> void:
	_start_game()

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if is_player and \
		event.is_action_released(&"move_up") or \
		event.is_action_released(&"move_down"):
		velocity = Vector2.ZERO
	else:
		if event.is_action_released(&"p2_move_up") or \
			event.is_action_released(&"p2_move_down"):
				velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if is_player:
		direction = Input.get_axis(&"move_up", &"move_down")
	#else:
		#direction = Input.get_axis(&"p2_move_up", &"p2_move_down")
	
	if direction:
		velocity.y = direction * SPEED
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		pass # this works as expected
