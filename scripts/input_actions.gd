class_name InputActions
extends RefCounted

static var MENU_ESC := &"menu_esc"
static var MOVE_LEFT := &"move_left"
static var MOVE_RIGHT := &"move_right"

static func is_any_pressed(event: InputEvent, actions: Array[StringName]) -> bool:
	for action in actions:
		if event.is_action_pressed(action):
			return true
	return false

static func is_any_released(event: InputEvent, actions: Array[StringName]) -> bool:
	for action in actions:
		if event.is_action_released(action):
			return true
	return false
