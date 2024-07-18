class_name SettingsMenu
extends Control

var master_bus = AudioServer.get_bus_index("Master")

@onready var back = $MarginContainer/VBoxContainer/Back as Button
@onready var pause_menu = $PauseMenu as PauseMenu
signal back_settings_menu



func _ready():
	back.button_down.connect(on_back_pressed)
	set_process(false)

func on_back_pressed() -> void:
	back_settings_menu.emit()
	set_process(false)

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func _on_brightness_slider_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_brightness = value


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
