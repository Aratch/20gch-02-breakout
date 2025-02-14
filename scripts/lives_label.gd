class_name LivesLabel
extends Label

const START_LIVES = 3

signal lives_at_zero

var lives : int = START_LIVES:
	set(v):
		lives = max(0, v)
		text = "Lives: " + str(lives)
		if lives == 0:
			lives_at_zero.emit()

func reset() -> void:
	lives = START_LIVES

func _ready() -> void:
	reset()

func subtract_life() -> void:
	lives -= 1
