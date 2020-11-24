extends Node2D

export (PackedScene) var Card

var item
onready var HUD = get_node("/root/main/UI/HUD")

func _ready():
	var rngen = RandomNumberGenerator.new()
	rngen.randomize()
	var rng = rngen.randi_range(0,ItemIndex.Items.size() - 1)
	item = ItemIndex.Items[rng]

func _on_TouchScreenButton_pressed():
	if HUD.current_card <= 3:
		var node = Card.instance()
		HUD.call_deferred("add_child", node)
		node.object = self
		node.position = HUD.get_node("card_pos").get_child(HUD.current_card).position
		HUD.current_card += 1

func _take():
	get_node("/root/main/UI/HUD/inventory")._add_item(item)
	HUD.current_card -= 1
	queue_free()
