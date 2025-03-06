extends Area2D

class_name Bomb
@export var explision_size = 1

func _on_cooldown_timer_timeout() -> void:
	queue_free()
	
 
