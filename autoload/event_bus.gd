# EventBus
extends Node

signal brick_broken(which: Brick)
signal game_paused
signal game_unpaused

# TODO: Maybe don't do this?
## key: StringName (requested)
## val: Array[Node] (the nodes to be notified)
#var reference_requests : Dictionary = {}
#var node_references : Dictionary = {}

#signal node_registered(name: StringName)

#func _ready() -> void:
	#node_registered.connect(_on_node_registered)

#func _on_node_registered(name: StringName):
	#if name in reference_requests:
		#pass

#func request_node_ref(from: Node, name: StringName):
	#if name not in node_references:
		#await node_registered
	#return node_references.get(name)

#func register_node_ref(node: Node, name: StringName):
	#node_references[name] = node
	#node_registered.emit(name)
