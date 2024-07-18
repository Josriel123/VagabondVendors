extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_completed = false
var slimes = 0
var ok = false
@onready var town_sheep = get_parent()


func _ready():
	$quest1_ui.visible = false
	$no_quest.visible = false
	$finished_quest.visible = false
	$quest1_active__ui.visible = false
	z_index = 7
	
func _process(_delta):
	slimes = town_sheep.slimes_collected
	
	if quest1_active:
		$quest1_active__ui/ProgressBar.value = slimes
		$quest1_active__ui/ProgressBar/Label.text = str(slimes) + "/" + "5"
		if slimes == 5:
			quest1_active = false
			quest1_completed = true
	
	if quest1_completed:
		if ok == false:
			$finished_quest.visible = true
			$quest1_active__ui.visible = false
		

func quest1_chat():
	if quest1_active:
		if $quest1_active__ui.visible == true:
			$quest1_active__ui.visible = false
		else:
			$quest1_active__ui.visible = true
		$quest1_ui.visible = false
	else :
		if $quest1_ui.visible == true:
			$quest1_ui.visible = false
		else:
			$quest1_ui.visible = true
		$quest1_active__ui.visible = false
	

func open_quest():

	if !quest1_completed:
		quest1_chat()
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false
		town_sheep.chatting = false

func close_quest():
	if !quest1_completed:
		quest1_chat()

func _on_yes_button_1_pressed():
	$quest1_ui.visible = false
	$quest1_active__ui.visible = true
	quest1_active = true
	slimes = 0
	emit_signal("quest_menu_closed")


func _on_no_button_1_pressed():
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")


func _on_acccept_pressed():
	ok = true
	$finished_quest.visible = false
	town_sheep.chatting = false
	town_sheep.in_quest = false
	
