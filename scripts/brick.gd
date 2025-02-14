@tool
class_name Brick
extends StaticBody2D

var collision_shape : RectangleShape2D
var color_rect : ColorRect

signal broken

@export var toughness := 1:
	set(v):
		toughness = v
		if toughness <= 0:
			broken.emit()
			queue_free()

func take_damage() -> void:
	toughness -= 1

func _ready() -> void:
	collision_shape = $CollisionShape2D.shape
	color_rect = $ColorRect
	if Engine.is_editor_hint():
		collision_shape.changed.connect(func ():
			color_rect.size = collision_shape.size
			)
	else:
		broken.connect(func():
			EventBus.brick_broken.emit(self)
			)
