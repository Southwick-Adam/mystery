extends Node2D

var health = 100.0
var max_health = 100.0
var health_fade = false

func _take_damage(num):
	health -= num
	_update_bar()
	if health <= 0 :
		queue_free()

func _update_bar():
	$healthTimer.stop()
	health_fade = false
	$body/health.modulate.a = 1
	$body/health/bar.scale.x = (health/max_health)
	$healthTimer.start()

func _process(_delta):
	if health_fade and $body/health.modulate.a > 0:
		$body/health.modulate.a -= 0.05
	
func _on_healthTimer_timeout():
	health_fade = true

func _on_TouchScreenButton_pressed():
	get_node("/root/main")._target_tapped(self)
