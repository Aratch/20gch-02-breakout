class_name Main
extends Node2D

signal game_ready
signal game_paused
signal game_unpaused

var paused := false
var ball: Ball

var started := false

func _point_and_round() -> void:
	if $Ball.position.x < 0:
		$Player2ScoreLabel.add_point()
	else:
		$Player1ScoreLabel.add_point()
	_start_new_round()

func _start_new_round() -> void:
	$Paddle._start_game()
	$Ball._start_game()

func pause() -> void:
	paused = true
	game_paused.emit()
	%MenuLayer.show()

func unpause() -> void:
	paused = false
	%MenuLayer.hide()
	game_unpaused.emit()

func restart() -> void:
	$Player1ScoreLabel.reset()
	$Player2ScoreLabel.reset()
	unpause()
	_start_new_round()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.MENU_ESC) and started:
		if not paused:
			pause()
		else:
			unpause()

func _ready() -> void:
	ball = $Ball
	$Ball.ball_exited.connect(_point_and_round)
	
	game_paused.connect($Ball.pause)
	game_paused.connect($Paddle.pause)
	
	game_unpaused.connect($Ball.unpause)
	game_unpaused.connect($Paddle.unpause)
	
	%StartGameButton.pressed.connect(func():
		game_ready.emit()
		%MenuLayer.hide()
		started = true
		%StartGameButton.disabled = true
		%ResumeButton.disabled = false
		%RestartGameButton.disabled = false)
	%ResumeButton.pressed.connect(func():
		unpause())
	%RestartGameButton.pressed.connect(func():
		restart())
	%QuitButton.pressed.connect(func():
		get_tree().quit())
