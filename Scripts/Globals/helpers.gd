extends Node

func create_timer(
	node: Node,
	duration: float,
	autostart: bool = true,
	one_shot: bool = true,
	) -> Timer:
	var timer = Timer.new()
	timer.wait_time = duration
	timer.autostart = autostart
	timer.one_shot = one_shot
	node.add_child(timer)
	return timer
