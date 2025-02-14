class_name ScoreLabel
extends Label

const START_SCORE = 0

var score : int:
	set(v):
		score = v
		text = "Score: " + str(score)

func _ready() -> void:
	reset()

func reset() -> void:
	score = START_SCORE

func add_point() -> void:
	score += 1
