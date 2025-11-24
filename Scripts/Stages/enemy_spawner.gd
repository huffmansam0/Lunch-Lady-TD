extends Node

signal second_elapsed_in_wave

@export var kid_scene: PackedScene = preload("res://Scenes/Enemies/Kid.tscn")

var wave_timer: Timer
var current_wave: int = 0
var seconds_elapsed_in_wave: int = 0
var wave_ongoing: bool = false

#spawn an enemy at a random X, 0, Z location on some interval
#in ready, set up a timer, conn

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	wave_timer = Helpers.create_timer(self, 1, false, false)
	wave_timer.timeout.connect(_on_wave_timer_elapsed)
	wave_timer.start()
	SignalBus.wave_started.connect(_on_wave_started)
	
func _on_wave_timer_elapsed():
	seconds_elapsed_in_wave += 1
	second_elapsed_in_wave.emit()
	
func _on_wave_started():
	seconds_elapsed_in_wave = 0
	current_wave += 1
	match current_wave:
		1:
			start_wave_1()
		2:
			start_wave_2()
		3:
			start_wave_3()
		4:
			start_wave_4()
		5:
			start_wave_5()
		6:
			start_wave_6()
		
	
func spawn_enemy() -> void:
	var kid_instance = kid_scene.instantiate()
	var spawn_location = Vector3(10, 0, -7)
	kid_instance.position = spawn_location
	add_child(kid_instance)
	
func spawn_enemies(num_enemies: int, interval: float):
	for i in num_enemies:
		spawn_enemy()
		await get_tree().create_timer(interval).timeout
	
func start_wave_1():
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_1)
	
func _on_second_elapsed_wave_1():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(8, 1)
	
func start_wave_2():
	second_elapsed_in_wave.disconnect(_on_second_elapsed_wave_1)
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_2)
	
func _on_second_elapsed_wave_2():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(16, 0.8)
	
func start_wave_3():
	second_elapsed_in_wave.disconnect(_on_second_elapsed_wave_2)
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_3)
	
func _on_second_elapsed_wave_3():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(32, 0.6)
	
func start_wave_4():
	second_elapsed_in_wave.disconnect(_on_second_elapsed_wave_3)
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_4)
	
func _on_second_elapsed_wave_4():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(64, 0.4)
	
func start_wave_5():
	second_elapsed_in_wave.disconnect(_on_second_elapsed_wave_4)
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_5)
	
func _on_second_elapsed_wave_5():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(128, 0.2)
	
func start_wave_6():
	second_elapsed_in_wave.disconnect(_on_second_elapsed_wave_5)
	second_elapsed_in_wave.connect(_on_second_elapsed_wave_6)

func _on_second_elapsed_wave_6():
	match seconds_elapsed_in_wave:
		1:
			spawn_enemies(256, 0.1)
