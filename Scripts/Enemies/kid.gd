extends CharacterBody3D
class_name Kid

const MOVESPEED: float = 3.0
const MAX_HP: float = 100.0
const BOUNTY: int = 1

const WAYPOINTS: Array[Vector3] = [
	# Column 1 (leftmost) - zigzag down
	Vector3(-8, 0, -7),
	Vector3(-8, 0, -4),
	Vector3(0, 0, -4),
	Vector3(0, 0, 0),
	Vector3(4, 0, 0),
	Vector3(4, 0, -5),
	Vector3(8, 0, -5),
	Vector3(8, 0, 5),
	Vector3(4, 0, 5),
	Vector3(4, 0, 3),
	Vector3(-3, 0, 3),
	Vector3(-3, 0, -1),
	Vector3(-9, 0, -1),
	Vector3(-9, 0, 2),
	Vector3(-6, 0, 2),
	Vector3(-6, 0, 5),
	Vector3(-9, 0, 5),
	Vector3(-9, 0, 9),
	Vector3(-4, 0, 9),
	Vector3(-4, 0, 5),
	Vector3(-1, 0, 5),
	Vector3(-1, 0, 9),
	Vector3(2, 0, 9),
	Vector3(2, 0, 7),
	Vector3(7, 0, 7),
	Vector3(7, 0, 11),
]
	
var current_waypoint_index = 0
var hp: float = MAX_HP

func advance(delta: float) -> void:
	if current_waypoint_index >= WAYPOINTS.size():
		velocity = Vector3.ZERO
		return
	
	var target = WAYPOINTS[current_waypoint_index]
	var direction = (target - global_position).normalized()
	velocity = direction * MOVESPEED
	
	if (global_position.distance_to(target) < 0.1):
		current_waypoint_index += 1
	
	move_and_slide()

func take_damage(damage: float):
	hp -= damage
	
	if (hp <= 0):
		die()

func die():
	CashManager.add_cash(BOUNTY)
	queue_free()
