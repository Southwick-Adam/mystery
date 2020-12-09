extends Node2D

var type
var item
var damage
var accuracy
var target
var obj_name

func _activate(obj, targ):
	obj_name = obj.item_name
	type = obj.type
	item = obj.name
	damage = obj.damage
	accuracy = obj.accuracy
	target = targ
#SORT BY TYPE
	if type == 0:
		_weapon()
	elif type == 1:
		_consumable()

func _weapon():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf() <= accuracy:
		target._take_damage(damage)
	else:
		print("MISS")

func _consumable():
	if obj_name == ("Health") and target.is_in_group("player"):
		target._take_damage(-damage)
	elif obj_name == ("Key"):
		target._unlock()
	
