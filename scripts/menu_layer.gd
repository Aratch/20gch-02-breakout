class_name MenuLayer
extends CanvasLayer

@onready var start_game_button = %StartGameButton
@onready var resume_button = %ResumeButton
@onready var restart_button = %RestartGameButton
@onready var quit_button = %QuitButton

func start_game() -> void:
	hide()
	%StartGameButton.disabled = true
	%ResumeButton.disabled = false
	%RestartGameButton.disabled = false
