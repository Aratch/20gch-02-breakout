class_name MenuLayer
extends CanvasLayer

@onready var start_game_button = %StartGameButton
@onready var resume_button = %ResumeButton
@onready var restart_button = %RestartGameButton
@onready var quit_button = %QuitButton

func _ready() -> void:
	show()

func reset() -> void:
	%StartGameButton.disabled = false
	%ResumeButton.disabled = true
	%RestartGameButton.disabled = true

func show_gameover() -> void:
	%InfoLabel.text = "Game Over! How about another game?"
	show()

func start_game() -> void:
	hide()
	%InfoLabel.text = "Game in Progress"
	%StartGameButton.disabled = true
	%ResumeButton.disabled = false
	%RestartGameButton.disabled = false
