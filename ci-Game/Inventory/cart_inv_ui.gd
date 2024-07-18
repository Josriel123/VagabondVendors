extends Control

@onready var inv: Inv = preload("res://Inventory/cart_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var player = get_parent().get_parent().get_child(0)
var is_open = false


func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(_delta):
	toggleInv()
	for i in range(min(inv.slots.size(), slots.size())):
		if Input.is_action_just_pressed("e") and slots[i].mouse_in_area:
			player.cart.eat(inv.slots[i].item)
		if Input.is_action_just_pressed("transfer") and slots[i].mouse_in_area:
			player.collect(inv.slots[i].item)
			player.cart.transfer(inv.slots[i].item)

func toggleInv():
	if player != null:
		if Input.is_action_just_pressed("cartInv") and player.cart_inv_area:
			if is_open:
				visible = false
				is_open = false
			else:
				visible = true
				is_open = true
		if player.cart_inv_area == false:
			if is_open:
				visible = false
				is_open = false

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
