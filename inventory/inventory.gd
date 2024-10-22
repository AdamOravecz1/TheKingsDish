extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

# Custom initialization function to set up the inventory
func initialize_inv(slot_count: int):
	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = InvSlot.new()

	emit_signal("update")

func insert(item: InvItem):
	var emptyslot = slots.filter(func(slot): return slot.item == null)
	if !emptyslot.is_empty():
		emptyslot[0].item = item
	update.emit()
	
func insert_to_place(item: InvItem, place: int):
	if place >= 0 and place < slots.size():
		var slot = slots[place]
		slot.item = item
		slot.amount = 1
		update.emit()

		
func remove_from_place(place: int):
	if place >= 0 and place < slots.size():
		var slot = slots[place]
		slot.item = null
		slot.amount = 0  # Optional: Reset the amount to 0
		update.emit()






	
