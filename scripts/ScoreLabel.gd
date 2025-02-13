class_name ScoreLabel
extends Label

var score : int = 0:
	set(v):
		score = v
		text = str(score)

func reset() -> void:
	score = 0

func add_point() -> void:
	score += 1
