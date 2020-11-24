extends Node2D

const SPEED = 200
const ACCELERATION = 0.4
var velocity = Vector2()

var inter_obj = []
onready var controler = get_node("/root/main/UI/HUD/control")

var in_range_targets = []
var range_boundry

var active_item

func _animate(anim):
	if get_parent().get_node("AnimationPlayer").current_animation != anim:
		get_parent().get_node("AnimationPlayer").play(anim)

func _process(_delta):
	var perc = (controler._get_value()[1]/controler.boundry) * 1.2
	var direction = controler._get_value()[0]
	velocity.x = lerp(velocity.x, SPEED * direction.x, ACCELERATION)
	velocity.y = lerp(velocity.y, SPEED * direction.y, ACCELERATION)
	velocity = velocity * perc
	velocity = $body.move_and_slide(velocity, Vector2(0,-1))
	var knob_angle = atan2(direction.y,direction.x)
	if direction != Vector2(0,0):
		$body.rotation = (knob_angle + PI/2)

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		if active_item != null and ((event.position - $body.global_position).length() < range_boundry):
			for targ in in_range_targets:
				var sprite = targ.get_node("body/Sprite")
				var boundry = (sprite.texture.get_size().x * sprite.global_scale.x)/2
				var event_dist = (event.position - targ.global_position).length()
				if event_dist < boundry:
					_item_used(targ)
					break

#ITEM IN USE
func _item_activate(item):
	active_item = item
	$body/range.visible = true
	$body/range.monitoring = true
	$body/range.scale = item.effect_range * Vector2(0.7,0.7)
	var range_s = $body/range/range
	range_boundry = (range_s.texture.get_size().x * range_s.global_scale.x)/2

func _item_used(targ):
	print(active_item.name + " hits " + targ.name)
	active_item = null
	$body/range.visible = false
	$body/range.monitoring = false
	in_range_targets.clear()



#AREAS MONITERING
func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("object"):
		inter_obj.append(area.get_parent())

func _on_Area2D_area_exited(area):
	if inter_obj.has(area.get_parent()):
		inter_obj.erase(area.get_parent())

func _on_range_body_entered(body):
	if active_item != null:
		if body.get_parent().is_in_group("mortal"):
			in_range_targets.append(body.get_parent())

func _on_range_body_exited(body):
	if body.get_parent().is_in_group("mortal") and in_range_targets.has(body.get_parent()):
		in_range_targets.erase(body.get_parent())
