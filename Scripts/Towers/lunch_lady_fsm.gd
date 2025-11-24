#Lunch Lady StateMachine
extends StateMachine
class_name LunchLadyStateMachine

var request_queue: Array = []

func _ready():
	add_state("idle")
	add_state("attacking")
	call_deferred("set_state", states.idle) #CLEANUP: Why would this need to be call_deferred?
	#TODO: once we've got this working, let's see what happens if we make this set_state directly instead of call_deferred

func _state_logic(delta: float):
	match state:
		states.idle:
			parent.idle(delta)
		states.attacking:
			parent.attacking(delta)
			
func _get_transition(delta: float):
	if request_queue.size() == 0:
		return
	
	var next_requested_state = request_queue.front()
	var new_state = null
	
	match state:
		states.idle:
			match next_requested_state:
				states.attacking:
					new_state = states.attacking
				_: #discard nonsense request and return
					request_queue.pop_front()
					return
		states.attacking:
			match next_requested_state:
				states.idle:
					new_state = states.idle
				_: #discard nonsense request and return
					request_queue.pop_front()
					return
					
	if new_state != null:
		request_queue.pop_front()
		
	return new_state
	
func _enter_state(new_state, old_state):
	pass
