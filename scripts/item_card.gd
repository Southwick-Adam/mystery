extends Node2D


var object
onready var boundry = Vector2()

func _ready():
	boundry.x = ($card.texture.get_size().x * $card.global_scale.x)/2
	boundry.y = ($card.texture.get_size().y * $card.global_scale.y)/2
#SET VALUES
	$title.text = object.item.name
	$icon.texture = object.item.texture
	$range.text = str(object.item.effect_range)
	#$accuracy.text = str(object.item.accuracy)
	#$cooldown.text = str(object.item.cooldown)
	#$damage.text = str(object.item.damage)

func _input(event):
	if (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist = (event.position - $card.global_position)
		if event_dist.x <= boundry.x and event_dist.y <= boundry.y:
			object._take()

func _process(_delta):
	if object == null:
		queue_free()
