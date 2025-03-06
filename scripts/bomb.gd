extends Area2D

class_name Bomb
@export var explision_size = 1
@onready var collision_shape_static_body: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _on_cooldown_timer_timeout() -> void:
	queue_free()
	print("BOOOOM!!!")
 
func _on_body_exited(body: Node2D) -> void:
	# Collision only after player exits bomb
	collision_shape_static_body.set_deferred("disabled",false)
