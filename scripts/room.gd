extends RigidBody2D


var size

func _make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.extents = size
	$CollisionShape2D.shape = s
	s.custom_solver_bias = 0.75