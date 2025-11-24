extends Node3D

@export var tower_scene: PackedScene

@onready var camera: Camera3D = $Camera

const TOWER_COST: int = 10

func _ready() -> void:
	CashManager.initialize(30)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if CashManager.get_current_cash() < TOWER_COST:
			return
		
		var mouse_pos = get_viewport().get_mouse_position()

		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000.0

		# Do a normal physics raycast
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		
		if result:
			var tower_instance = tower_scene.instantiate()
			var tower_collision_shape = tower_instance.get_node("CollisionShape3D")
			
			var collision_query = PhysicsShapeQueryParameters3D.new()
			collision_query.shape = tower_collision_shape.shape
			collision_query.transform.origin = result.position
			collision_query.collision_mask = 6 #is there a way to get this from project layers instead of hard coding?
			
			var collision_result = get_world_3d().direct_space_state.intersect_shape(collision_query)
			
			if !collision_result:
				tower_instance.position = result.position
				add_child(tower_instance)
				CashManager.try_remove_cash(TOWER_COST)
			else:
				tower_instance.queue_free()
