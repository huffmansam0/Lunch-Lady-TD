extends CanvasLayer

@onready var cash_label: Label = $CashLabel
@onready var start_wave_button: Button = $StartWaveButton

func _ready() -> void:
	CashManager.current_cash_changed.connect(_on_current_cash_changed)
	start_wave_button.pressed.connect(_on_start_wave_button_pressed)
	
func _on_start_wave_button_pressed():
	SignalBus.wave_started.emit()
	
func _on_current_cash_changed(new_balance: int):
	cash_label.text = "Cash: " + str(new_balance)
