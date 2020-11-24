extends Node2D
class_name Inventory

export(Array, Resource) var inventory = [null,null,null,null,null]

var ongoing_drag = -1
var btn_used = null
onready var boundry = ($slots/slot1/box.texture.get_size().x * $slots/slot1/box.global_scale.x)/2
var dragging = false
var item_selected = null

func _update():
	var n = 0
	while n < 5:
		if inventory[n] != null:
			$slots.get_child(n).get_child(1).texture = inventory[n].texture
			$timers.get_child(n).wait_time = inventory[n].cooldown + 1
		else:
			$slots.get_child(n).get_child(1).texture = null
		n += 1

func _add_item(new_item):
	var n = 0
	while n < 5:
		if inventory[n] == null:
			inventory[n] = new_item
			break
		n += 1
	_update()

func _swap_items(slot, target_slot):
	var targetItem = inventory[target_slot]
	var item = inventory[slot]
	inventory[target_slot] = item
	inventory[slot] = targetItem
	_update()

func _remove_item(slot):
	var object = inventory[slot]
	inventory[slot] = null
	_update()
	_drop_item(object)

func _drop_item(object):
	inventory[object] = null
	_update()

func _input(event):
	if btn_used != null:
		if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
			var event_dist = (event.position - btn_used.global_position).length()
			var icon = btn_used.get_child(1)
			if event_dist > boundry and $Timer.time_left > 0:
				$Timer.stop()
			if (event_dist <= boundry or event.get_index() == ongoing_drag) and dragging:
				icon.global_position = event.position #ICON FOLLOWS FINGER
				ongoing_drag = event.get_index()
#RELEASED
		if event is InputEventScreenTouch and !event.is_pressed():
			$Timer.stop()
			if event.get_index() == ongoing_drag:
				ongoing_drag = -1 #RESET DRAG
			var event_dist = (event.position - btn_used.global_position).length()
			var icon = btn_used.get_child(1)
#INSIDE ORIGINAL BOX
			if event_dist <= boundry + 10:
				if not dragging:
					get_node("/root/main/player")._item_activate(inventory[item_selected]) #ITEM IS BEING USED
			elif event.position.x - btn_used.global_position.x < -70:
				if dragging:
					_drop_item(item_selected)
			icon.position = Vector2(0,0)
			if abs(event.position.x - btn_used.global_position.x) < boundry and dragging:
				var btn_pos_aray = []
				var n = 0
				while n < 5:
					btn_pos_aray.append((event.position - $slots.get_child(n).global_position).length())
					n += 1
				var chosen_slot = btn_pos_aray.find(btn_pos_aray.min())
				_swap_items(item_selected, chosen_slot)
			dragging = false
			btn_used = null

func _on_slot1_pressed():
	_pressed(0)
func _on_slot2_pressed():
	_pressed(1)
func _on_slot3_pressed():
	_pressed(2)
func _on_slot4_pressed():
	_pressed(3)
func _on_slot5_pressed():
	_pressed(4)
func _pressed(num):
	if btn_used == null:
		$Timer.start()
		btn_used = $slots.get_child(num)
		item_selected = num

func _on_Timer_timeout():
	dragging = true
