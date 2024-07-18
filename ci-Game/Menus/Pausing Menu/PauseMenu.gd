class_name PauseMenu 
extends Control

@onready var settings = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Settings as Button
@onready var settings_menu = $SettingsMenu as SettingsMenu
@onready var panel_container = $PanelContainer as PanelContainer

func _ready():
	resume()
	handle_connecting_signals()
	$AnimationPlayer.play_backwards("RESET")
	

func resume():
	hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	show()
	get_tree().paused = true
	panel_container.visible = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()
		settings_menu.set_process(false)
		settings_menu.visible = false 
		  

func _on_resume_pressed():
	resume()


func _on_settings_pressed():
	panel_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards("blur")
	

func _on_back_settings_menu() -> void:
	panel_container.visible = true
	settings_menu.set_process(false)
	settings_menu.visible = false

func handle_connecting_signals() -> void:
	settings.button_down.connect(_on_settings_pressed)
	settings_menu.back_settings_menu.connect(_on_back_settings_menu)

func _process(_delta):
	testEsc()
	
func _on_main_menu_pressed():
	resume()
	get_tree().change_scene_to_file("res://Menus/Main Menu/Main Menu.tscn")
