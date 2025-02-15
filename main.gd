class_name Main
extends Node2D

signal game_ready
signal game_paused
signal game_unpaused

var paused := false
var ball: Ball

var started := false

var bricks : Array[Brick] = []

func _on_ball_exited() -> void:
	%LivesLabel.subtract_life()
	if %LivesLabel.lives > 0:
		_start_new_round()

func _start_new_round() -> void:
	#$Paddle._start_game()
	$Ball._start_game()

func pause() -> void:
	paused = true
	game_paused.emit()
	%MenuLayer.show()

func game_over() -> void:
	paused = true
	game_paused.emit()
	%MenuLayer.reset()
	%MenuLayer.show_gameover()

func game_won() -> void:
	paused = true
	game_paused.emit()
	%MenuLayer.reset()
	%MenuLayer.show_winscreen()

func unpause() -> void:
	paused = false
	%MenuLayer.hide()
	game_unpaused.emit()

func restart() -> void:
	%ScoreLabel.reset()
	%LivesLabel.reset()
	unpause()
	_start_new_round()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.MENU_ESC) and started:
		if not paused:
			pause()
		else:
			unpause()

func _ready() -> void:
	for node in get_tree().get_nodes_in_group(&"bricks"):
		var brick := node as Brick
		bricks.append(brick)
		
	ball = $Ball
	$Ball.ball_exited.connect(_on_ball_exited)
	
	game_paused.connect($Ball.pause)
	game_paused.connect($Paddle.pause)
	
	game_unpaused.connect($Ball.unpause)
	game_unpaused.connect($Paddle.unpause)
	
	%MenuLayer.start_game_button.pressed.connect(func():
		game_ready.emit()
		started = true
		%MenuLayer.start_game()
		)
	%MenuLayer.resume_button.pressed.connect(func():
		unpause())
	%MenuLayer.restart_button.pressed.connect(func():
		restart())
	%MenuLayer.quit_button.pressed.connect(func():
		get_tree().quit())
		
	EventBus.brick_broken.connect(func(which: Brick):
		%ScoreLabel.add_point()
		bricks.erase(which)
		if bricks.is_empty():
			game_won()
		)
	
	%LivesLabel.lives_at_zero.connect(game_over)
