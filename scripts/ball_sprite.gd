@tool
class_name BallSprite extends Sprite2D

@export var radius : int = 50:
	set(v):
		radius = v
		queue_redraw()

func _draw() -> void:
	draw_circle(position, radius, Color.WHITE, true, -1.0, true)
