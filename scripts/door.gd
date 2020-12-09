extends Node2D

var health = 0
var locks = 0
var heavy = 0
var puzzles = 0

var pushers = []

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rngen = rng.randf()
	if rngen < 0.4:
		_locks()
	elif rngen < 0.8:
		_health()
	elif rngen < 0.1:
		_heavy()

func _locks():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	locks += rng.randi_range(1,2)

func _health():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	health += rng.randi_range(10,50)

func _heavy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	heavy += rng.randi_range(1,3)

func _on_TouchScreenButton_pressed():
	get_node("/root/main")._door_tapped(self)
	_check()

func _take_damage(num):
	if num >= health:
		health = 0
		_check()

func _unlock():
	locks -= 1
	_check()

func _check():
	if locks <= 0 and health == 0 and pushers.size() >= heavy:
		queue_free()
