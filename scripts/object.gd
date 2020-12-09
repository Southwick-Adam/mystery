extends Node2D

export (PackedScene) var Card

var item
var item_name
var stackable
var type
var texture
var reusable
var effect_range
var cooldown
var damage
var accuracy
var uses
onready var main = get_node("/root/main")
onready var HUD = get_node("/root/main/HUD")
onready var player = get_node("/root/main/player")

const ACCELERATION = 0.085
var velocity = Vector2()

onready var source = $Area2D

func _ready():
	var rngen = RandomNumberGenerator.new()
	rngen.randomize()
	velocity.x = rngen.randi_range(-10,10)
	rngen.randomize()
	velocity.y = rngen.randi_range(-10,10)
	rngen.randomize()
	var rng = rngen.randi_range(0,ItemIndex.Items.size() - 1)
	item = load(ItemIndex.Items[rng])
	_set_values()

func _set_values():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	item_name = item.name
	stackable = item.stackable
	type = item.type
	texture = item.texture
	reusable = item.reusable
	effect_range = item.effect_range * rng.randf_range(0.9, 1.1)
	cooldown = item.cooldown
	$Timer.wait_time = item.cooldown
	rng.randomize()
	damage = item.damage * rng.randf_range(0.85, 1.15)
	rng.randomize()
	accuracy = item.accuracy * rng.randf_range(0.9, 1.1)
	uses = item.uses

func _on_TouchScreenButton_pressed():
	var card = main.HUD_card
	if player.inter_obj.has(self):
		if card != null:
			card.queue_free()
		var node = Card.instance()
		HUD.call_deferred("add_child", node)
		node.object = self
		node.global_position = HUD.get_node("card_pos").global_position
		card = node

func _take():
	main._add_item(self)
	main.HUD_card = null
	set_process(false)
	for child in get_children():
		child.queue_free()

func _process(_delta):
	velocity.x = lerp(velocity.x, 0, ACCELERATION)
	velocity.y = lerp(velocity.y, 0, ACCELERATION)
	position += velocity
