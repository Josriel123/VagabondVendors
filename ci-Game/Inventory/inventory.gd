extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var  itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	update.emit()

func delete(item: InvItem):
	var  itemSlots = slots.filter(func(slot): return slot.item == item)
	if item != null:
		itemSlots[0].amount -= 1
		if itemSlots[0].amount <= 0:
			itemSlots[0].item = null
	update.emit()

