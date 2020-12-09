extends Node2D


export (PackedScene) var Door
export (PackedScene) var Chest

var room_level = [2,4,4,4,4,5,3,1,2,2,1,1,2,1,1,2,2,3,1,2,3,4]
var spawn_size = [5,3,4,3,2,2,4,4,4,3,3,5,1,3,2,3,2,3,3,3,2,2]

var rooms = {
	"room1" : [Vector2(-42,-29),Vector2(23,15)],
	"room2" : [Vector2(-42,-12),Vector2(10,17)],
	"room3" : [Vector2(-42,7),Vector2(15,15)],
	"room4" : [Vector2(-42,24),Vector2(15,9)],
	"room5" : [Vector2(-30,-12),Vector2(5,5)],
	"room6" : [Vector2(-30,0),Vector2(3,5)],
	"room7" : [Vector2(-17,-12),Vector2(17,12)],
	"room8" : [Vector2(-17,2),Vector2(17,15)],
	"room9" : [Vector2(-17,19),Vector2(17,14)],
	"room10" : [Vector2(-10,-29),Vector2(17,9)],
	"room11" : [Vector2(2,19),Vector2(12,14)],
	"room12" : [Vector2(9,-29),Vector2(17,23)],
	"room13" : [Vector2(24,18),Vector2(6,2)],
	"room14" : [Vector2(24,22),Vector2(11,11)],
	"room15" : [Vector2(26,1),Vector2(9,10)],
	"room16" : [Vector2(28,-29),Vector2(15,13)],
	"room17" : [Vector2(33,-14),Vector2(5,13)],
	"room18" : [Vector2(37,1),Vector2(12,9)],
	"room19" : [Vector2(37,12),Vector2(12,10)],
	"room20" : [Vector2(37,24),Vector2(12,9)],
	"room21" : [Vector2(45,-29),Vector2(4,10)],
	"room22" : [Vector2(45,-17),Vector2(4,11)],
}

func _ready():
	_create_rooms()

func _create_rooms():
	var n = 0
	for room in rooms:
		var origin = $TileMap.map_to_world(rooms[room][0])
		var room_center = origin + (rooms[room][1] * 16) - Vector2(16,-16)
		var area = $rooms.get_child(n)
		area.global_position = room_center
		var col = CollisionShape2D.new()
		area.add_child(col)
		col.shape = RectangleShape2D.new()
		var room_size = (rooms[room][1] + Vector2(1,1)) * 16
		col.shape.extents = room_size
		area.get_child(0).self_modulate = Color(0.168627, 0.168627, 0.168627)
		area.get_child(0).scale = rooms[room][1] + Vector2(1.2,1.2)
		_spawn_items(room_center, room_size - Vector2(25,25), n)
		n += 1
	_spawn_doors()

func _spawn_doors():
	var cell1 = $TileMap.get_used_cells_by_id(1)
	var cell2 = $TileMap.get_used_cells_by_id(2)
	for cell in cell1:
		var node = Door.instance()
		add_child(node)
		node.global_position = $TileMap.map_to_world(cell) + Vector2(-16,16)
	for cell in cell2:
		var node = Door.instance()
		add_child(node)
		node.global_position = $TileMap.map_to_world(cell) + Vector2(-16,16)
		node.rotation_degrees = 90

func _spawn_items(center, size, n):
	var m = spawn_size[n]
	while m > 0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if rng.randf() >= 0.5:
			rng.randomize()
			var rngx = rng.randf_range(-size.x,size.x)
			rng.randomize()
			var rngy = rng.randf_range(-size.y,size.y)
			var spawn_pos = center + Vector2(rngx,rngy)
			_spawn(spawn_pos)
		m -= 1
	
func _spawn(pos):
	var node = Chest.instance()
	add_child(node)
	node.global_position = pos
	
func _room_enter(num, body):
	if body.get_parent() == get_node("/root/main/player"):
		_cover()
		if num < 30:
			$rooms.get_child(num).get_child(0).visible = false
		else:
			$hallways.get_child(num - 30).get_child(1).visible = false
		
func _cover():
	for room in $rooms.get_children():
		room.get_child(0).visible = true
	for room in $hallways.get_children():
		room.get_child(1).visible = true 




func _on_room1_body_entered(body):
	_room_enter(0, body)
func _on_room2_body_entered(body):
	_room_enter(1, body)
func _on_room3_body_entered(body):
	_room_enter(2, body)
func _on_room4_body_entered(body):
	_room_enter(3, body)
func _on_room5_body_entered(body):
	_room_enter(4, body)
func _on_room6_body_entered(body):
	_room_enter(5, body)
func _on_room7_body_entered(body):
	_room_enter(6, body)
func _on_room8_body_entered(body):
	_room_enter(7, body)
func _on_room9_body_entered(body):
	_room_enter(8, body)
func _on_room10_body_entered(body):
	_room_enter(9, body)
func _on_room11_body_entered(body):
	_room_enter(10, body)
func _on_room12_body_entered(body):
	_room_enter(11, body)
func _on_room13_body_entered(body):
	_room_enter(12, body)
func _on_room14_body_entered(body):
	_room_enter(13, body)
func _on_room15_body_entered(body):
	_room_enter(14, body)
func _on_room16_body_entered(body):
	_room_enter(15, body)
func _on_room17_body_entered(body):
	_room_enter(16, body)
func _on_room18_body_entered(body):
	_room_enter(17, body)
func _on_room19_body_entered(body):
	_room_enter(18, body)
func _on_room20_body_entered(body):
	_room_enter(19, body)
func _on_room21_body_entered(body):
	_room_enter(20, body)
func _on_room22_body_entered(body):
	_room_enter(21, body)
func _on_Area2D_body_entered(body):
	_room_enter(30, body)
func _on_Area2D2_body_entered(body):
	_room_enter(31, body)
func _on_Area2D3_body_entered(body):
	_room_enter(32, body)
func _on_Area2D4_body_entered(body):
	_room_enter(33, body)
func _on_Area2D5_body_entered(body):
	_room_enter(34, body)
