@tool
extends Paddle

var ball: Ball
var game_ready := false
var frozen := false

const EPSILON = 200.0

func _ready() -> void:
#	get_owner().game_ready.connect(_on_game_ready)
	set_process_input(false)
	super._ready()

func get_rand_time(state: bool) -> float:
	if not state: # current state is not frozen, i.e. the previous was frozen
		return randf_range(0.1, 1.0)
	else: # and vice versa
		return randf_range(0.05, 0.2)

func _start_freeze_timer() -> void:
	$BrainFreezeTimer.wait_time = get_rand_time(frozen)
	$BrainFreezeTimer.timeout.connect(_on_freeze_timer_timeout, CONNECT_ONE_SHOT)
	$BrainFreezeTimer.start()

func _on_freeze_timer_timeout() -> void:
	frozen = not frozen
	_start_freeze_timer()

func _on_game_ready() -> void:
	super._start_game()
	ball = get_owner().ball
	game_ready = true
	_start_freeze_timer()
	
func _physics_process(delta: float) -> void:
	if ball and game_ready and not frozen:
		# This adds a bit of uncertainty/jitteriness, but not enough on its own
		var will_follow : bool = (randi() % 3 == 0)
		if ball.position.y - position.y > -EPSILON and will_follow:
			direction = 1.0
		elif ball.position.y - position.y < EPSILON and will_follow:
			direction = -1.0
		else:
			direction = 0.0
		super._physics_process(delta)
