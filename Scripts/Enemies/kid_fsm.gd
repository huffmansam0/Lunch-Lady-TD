#Kid StateMachine
extends StateMachine

var request_queue: Array = []

func _ready():
	add_state("advance")
	add_state("die")
	call_deferred("set_state", states.advance) #CLEANUP: Why would this need to be call_deferred?
	#TODO: once we've got this working, let's see what happens if we make this set_state directly instead of call_deferred

func _state_logic(delta: float):
	match state:
		states.advance:
			parent.advance(delta)
			
func _get_transition(delta: float):
	if request_queue.size() == 0:
		return
	
	var next_requested_state = request_queue.front()
	var new_state = null
	
	match state:
		states.advance:
			match next_requested_state:
				states.die:
					new_state = states.die
				_: #discard nonsense request and return
					request_queue.pop_front()
					return
					
	if new_state != null:
		request_queue.pop_front()
		
	return new_state
	
func _enter_state(new_state, old_state):
	match new_state:
		states.die:
			parent.die()
