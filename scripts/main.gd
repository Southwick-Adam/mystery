extends Node2D

#INVENTORY
export(Array, Resource) var inventory = [null,null,null,null,null]

var taken_slots = 0
var active_item = null
var slot_num = null
onready var player = get_node("player")
onready var HUD_inventory = get_node("HUD/inventory")

var HUD_card = null

#INVENTORY MANAGEMENT
func _add_item(new_item):
	taken_slots += 1
	var n = 0
	while n < 5:
		if inventory[n] == null:
			inventory[n] = new_item
			break
		n += 1
	HUD_inventory._update()

func _swap_items(slot, target_slot):
	var targetItem = inventory[target_slot]
	var item = inventory[slot]
	inventory[target_slot] = item
	inventory[slot] = targetItem
	HUD_inventory._update()

func _drop_item(slot):
	taken_slots -= 1
	inventory[slot] = null
	HUD_inventory._update()
	#CODE ABOUT SPAWNING OBJECT

func _erase_item(object):
	taken_slots -= 1
	if inventory.has(object):
		inventory[inventory.find(object)] = null
	HUD_inventory._update()

#PLAYER INPUTS
func _target_tapped(target):
	if active_item != null and player.in_range_targets.has(target):
		_item_used(target)

func _door_tapped(door):
	if active_item == null:
		door.pushers.append(player)
		print(door.health, door.locks, door.heavy)
	else:
		_item_used(door)

#USING ITEMS
func _item_activate(item):
	slot_num = item
	player._item_activate(inventory[item].effect_range)
	active_item = inventory[item]
	HUD_inventory._color_change(slot_num, false)

func _item_used(target):
	ItemEffects._activate(active_item, target)
	active_item.uses -= 1
	if active_item.uses == 0 and active_item.stackable == true:
		_erase_item(active_item)
	HUD_inventory._update()
	if not active_item.reusable:
		player._item_used()
		active_item = null
		HUD_inventory._color_change(slot_num, true)

func _deactivate_item():
	player._item_used()
	active_item = null
	HUD_inventory._color_change(slot_num, true)
