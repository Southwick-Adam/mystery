extends Node2D
class_name Inventory

var ongoing_drag = -1
var btn_used = null
onready var boundry = ($slots/slot1/box.texture.get_size().x * $slots/slot1/box.global_scale.x)/2
var dragging = false
var item_selected = null

onready var main = get_node("/root/main")
onready var inventory = main.inventory

func _update():
	var n = 0
	while n < 5:
		if inventory[n] != null:
			var inv = inventory[n]
			$slots.get_child(n).get_child(1).texture = inv.texture
			$timers.get_child(n).wait_time = inv.cooldown + 1
			if (inv.uses >= 0 and not inv.stackable) or (inv.uses > 1 and inv.stackable):
				$slots.get_child(n).get_child(2).text = str(inventory[n].uses)
			else:
				$slots.get_child(n).get_child(2).text = ""
		else:
			$slots.get_child(n).get_child(1).texture = null
			$slots.get_child(n).get_child(2).text = ""
		n += 1

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
					if inventory[item_selected] != null:
						if inventory[item_selected].uses != 0:
							get_node("/root/main")._item_activate(item_selected) #ITEM IS BEING USED
			elif event.position.x - btn_used.global_position.x < -70:
				if dragging:
					main._drop_item(item_selected)
			icon.position = Vector2(0,0)
			if abs(event.position.x - btn_used.global_position.x) < boundry and dragging:
				var btn_pos_aray = []
				var n = 0
				while n < 5:
					btn_pos_aray.append((event.position - $slots.get_child(n).global_position).length())
					n += 1
				var chosen_slot = btn_pos_aray.find(btn_pos_aray.min())
				main._swap_items(item_selected, chosen_slot)
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
		if main.active_item == null:
			$Timer.start()
			btn_used = $slots.get_child(num)
			item_selected = num
		elif main.active_item == main.inventory[num]:
			main._deactivate_item()

func _on_Timer_timeout():
	dragging = true

func _color_change(num, ident):
	if ident:
		$slots.get_child(num).get_child(0).self_modulate = Color(0.286275, 0.462745, 0.521569, 0.470588)
	else:
		$slots.get_child(num).get_child(0).self_modulate = Color(0.627451, 0.258824, 0.258824, 0.470588)
