extends Node

@export var cafeteria_scene: PackedScene

@onready var level_container = $LevelContainer

func _ready() -> void:
	var cafeteria_scene_instance = cafeteria_scene.instantiate()
	level_container.add_child(cafeteria_scene_instance)
	#pass
