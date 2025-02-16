@tool
class_name Ball extends CharacterBody2D

const SPEED = 600.0
var current_speed

var collision_shape : CircleShape2D
var ball_sprite : BallSprite
var vis_notifier : VisibleOnScreenNotifier2D

const START_DIRECTIONS := [Vector2.UP]

signal ball_exited

func _set_up_setters():
	collision_shape.changed.connect(func ():
		var new_radius := collision_shape.radius
		ball_sprite.radius = new_radius
		vis_notifier.rect.size.x = new_radius
		vis_notifier.rect.size.y = new_radius
		vis_notifier.position.x = -(new_radius/2)
		vis_notifier.position.y = -(new_radius/2)
		)

func _set_to_initial_pos() -> void:
	var window_size := DisplayServer.window_get_size()
	position.x = window_size.x / 2.0
	position.y = window_size.y / 2.0

func _start_game() -> void:
	unpause()
	_set_to_initial_pos()
	current_speed = SPEED
	velocity = START_DIRECTIONS.pick_random()
	
func pause() -> void:
	set_physics_process(false)

func unpause() -> void:
	set_physics_process(true)

func _ready() -> void:
	collision_shape = $CollisionShape2D.shape
	ball_sprite = $BallSprite
	vis_notifier = $VisibleOnScreenNotifier2D
	
	pause()
	
	if Engine.is_editor_hint():
		_set_up_setters()
	else:
		vis_notifier.screen_exited.connect(func():
			ball_exited.emit())
		get_owner().game_ready.connect(_on_game_ready)
		EventBus.game_paused.connect(pause)
		EventBus.game_unpaused.connect(unpause)
		EventBus.brick_broken.connect(func(_which: Brick):
			current_speed += 15.0)
		
func _on_game_ready() -> void:
	_start_game()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var collision := move_and_collide(velocity * delta * current_speed)
	if collision:
		var normal := collision.get_normal()
		var collider := collision.get_collider()
		if collider:
			var collider_velocity : Vector2 = Vector2.ZERO	
			if collider is Brick:
				var brick = collider as Brick
				brick.take_damage()
			if collider is CharacterBody2D:
				collider_velocity = (collider as CharacterBody2D).velocity
				velocity = (normal + 0.001 * collider_velocity).normalized()
			else:
				# velocity *= -1
				velocity = velocity.bounce(normal)
		# Add some jitter if we're stuck
		if collision.get_depth() > 0.3 and is_zero_approx(velocity.x):
			velocity.x = randfn(0.0, 1.0)
