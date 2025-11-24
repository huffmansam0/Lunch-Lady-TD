extends CharacterBody3D
class_name Attack

@onready var hitbox = $Hitbox

const TIME_TO_LIVE: float = 0.33333

var movespeed: float
var damage: float
var destination: Vector3

func setup(_position: Vector3, _movespeed: float, _damage: float, _destination: Vector3) -> void:
	position = _position
	movespeed = _movespeed
	damage = _damage
	destination = _destination

func _enter_tree() -> void:
	var move_direction = global_position.direction_to(destination)
	velocity = move_direction * movespeed

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	Helpers.create_timer(self, TIME_TO_LIVE).timeout.connect(_time_to_live_timeout)
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
	
func _on_hitbox_body_entered(body: Node3D):
	body.take_damage(damage)
	queue_free()
	
func _time_to_live_timeout():
	queue_free()
