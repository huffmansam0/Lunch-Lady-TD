extends Node

signal current_cash_changed(new_balance: int)

var current_cash: int:
	set(value):
		current_cash = value
		current_cash_changed.emit(current_cash)

func initialize(starting_cash: int):
	current_cash = starting_cash

func get_current_cash() -> int:
	return current_cash

func add_cash(amount: int):
	current_cash += amount
	
func try_remove_cash(amount: int) -> bool:
	if current_cash >= amount:
		current_cash -= amount
		return true
	return false
