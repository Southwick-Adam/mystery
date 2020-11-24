extends Node2D

export (PackedScene) var Room

var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 25  # number of rooms to generate
var min_size = 4  # minimum room size (in tiles)
var max_size = 10  # maximum room size (in tiles)
var cull = 0.4 # chance to cull room

func _ready():
	randomize()
	_make_rooms()

func _make_rooms():
	for i in range(num_rooms):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var pos = Vector2(0, 0)
		var node = Room.instance()
		var w = rng.randi_range(min_size, max_size)
		rng.randomize()
		var h = rng.randi_range(min_size, max_size)
		node._make_room(pos, Vector2(w, h) * tile_size)
		add_child(node)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	# cull rooms
	var cull_count = 0
	for room in get_children():
		if randf() < cull and cull_count < 9:
			room.queue_free()
			cull_count += 1
		else:
			room.mode = RigidBody2D.MODE_STATIC

func _draw():
	for room in get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2),
				Color(32, 228, 0), false)

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in get_children():
			n.queue_free()
		_make_rooms()
