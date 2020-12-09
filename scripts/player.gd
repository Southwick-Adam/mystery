extends Node2D

const SPEED = 200
const ACCELERATION = 0.4
var velocity = Vector2()

onready var controler = get_node("/root/main/HUD/control")
onready var inventory = get_node("/root/main/HUD/inventory")

var inter_obj = []
var in_range_targets = []
var range_boundry

var health = 100.0
var max_health = 100.0

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

#ITEM IN USE
func _item_activate(effect_range):
	$body/range.visible = true
	$body/range.monitoring = true
	$body/range.scale = effect_range * Vector2(1,1)
	var range_s = $body/range/range
	range_boundry = (range_s.texture.get_size().x * range_s.global_scale.x)/2

func _item_used():
	$body/range.visible = false
	$body/range.monitoring = false
	in_range_targets.clear()

#AREAS MONITERING
func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("interactable"):
		inter_obj.append(area.get_parent())

func _on_Area2D_area_exited(area):
	if inter_obj.has(area.get_parent()):
		inter_obj.erase(area.get_parent())

func _on_Area2D_body_entered(body):
	if body.get_parent().is_in_group("interactable"):
		inter_obj.append(body.get_parent())

func _on_Area2D_body_exited(body):
	if inter_obj.has(body.get_parent()):
		inter_obj.erase(body.get_parent())

func _on_range_body_entered(body):
	if body.get_parent().is_in_group("targetable"):
		in_range_targets.append(body.get_parent())

func _on_range_body_exited(body):
	if in_range_targets.has(body.get_parent()):
		in_range_targets.erase(body.get_parent())

func _on_TouchScreenButton_pressed():
	get_node("/root/main")._target_tapped(self)


func _take_damage(num):
	health -= num
