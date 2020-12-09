extends Node2D

var object
onready var boundry = Vector2()
onready var player = get_node("/root/main/player/body")
var fade = false

func _ready():
#SET VALUES
	$title.text = object.item_name
	$icon.texture = object.texture
	$range.text = str(round(object.effect_range * 5))
	if round(object.accuracy * 100) > 100:
		$accuracy.text = "100%"
	else:
		$accuracy.text = str(round(object.accuracy * 100)) + "%"
	$cooldown.text = str(object.cooldown)
	$damage.text = str(round(object.damage))

func _process(_delta):
	var source_dist = (player.global_position - object.source.global_position).length()
	if source_dist > 85:
		fade = true
	if fade:
		modulate.a -= 0.05
		if modulate.a < 0.05:
			queue_free()
	if object == null:
		queue_free()

func _on_TouchScreenButton_pressed():
	if not fade and get_node("/root/main").taken_slots < 5:
		object._take()
		queue_free()
