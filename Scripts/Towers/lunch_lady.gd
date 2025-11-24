extends CharacterBody3D
class_name LunchLady

@export var attack_scene: PackedScene

@onready var attack_range_area: Area3D = $AttackRange
@onready var attack_range_shape: CollisionShape3D = $AttackRange/CollisionShape3D
@onready var state_machine: LunchLadyStateMachine = $StateMachine

const ATTACK_RADIUS_WIGGLE_ROOM: float = 0.5
const ATTACK_INTERVAL: float = 0.75
const BASE_ATTACK_MOVESPEED: float = 12.0
const BASE_ATTACK_DAMAGE: float = 25.0

var target_queue: Array[Kid] = []
var attack_timer: Timer
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var attack_ready: bool = true

func _ready() -> void:
	attack_range_area.body_entered.connect(enemy_entered_attack_range)
	
	attack_timer = Timer.new()
	attack_timer.wait_time = ATTACK_INTERVAL
	attack_timer.one_shot = true
	attack_timer.timeout.connect(on_attack_timer_timeout)
	add_child(attack_timer)

func enemy_entered_attack_range(body: Node3D) -> void:
	target_queue.append(body)
	
func on_attack_timer_timeout() -> void:
	attack_ready = true
	
func request_idle():
	state_machine.request_queue.append(state_machine.states.idle)
	
func request_attacking():
	state_machine.request_queue.append(state_machine.states.attacking)

func idle(delta: float):
	#TODO: could reset rotation or maybe handle swapping to an idle animation or something here
	if (!target_queue.is_empty()):
		request_attacking()
	
func attacking(delta: float):
	if (target_queue.is_empty()):
		request_idle()
		return
		
	var target = target_queue.front()
	var attack_radius: float = (attack_range_shape.shape as SphereShape3D).radius + ATTACK_RADIUS_WIGGLE_ROOM
	
	while (target_queue.size() > 0 and (!is_instance_valid(target) or global_position.distance_to(target.global_position) > attack_radius)):
		target_queue.pop_front()
		if target_queue.size() > 0:
			target = target_queue.front()
	
	if is_instance_valid(target):
		if (attack_ready):
			attack(target.global_position)
			attack_ready = false
			attack_timer.start()
		#rotate to face the enemy?

	#TODO: if so, spawn an attack with a destination .. handle cooldown
	
func attack(destination: Vector3):
	var attack_instance = attack_scene.instantiate() as Attack
	attack_instance.setup(global_position, BASE_ATTACK_MOVESPEED, BASE_ATTACK_DAMAGE, destination)
	get_parent().add_child(attack_instance)
		
