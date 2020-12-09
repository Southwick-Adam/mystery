extends Node2D

export (PackedScene) var Obj

onready var main = get_node("/root/main")
onready var player = get_node("/root/main/player")

var contents = []

func _on_TouchScreenButton_pressed():
	print("test")
	if player.inter_obj.has(self):
		_open()

func _open():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var n = rng.randi_range(1,3)
	while n > 0:
		var node = Obj.instance()
		main.call_deferred("add_child", node)
		node.global_position = global_position
		n -= 1
