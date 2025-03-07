extends Area2D

class_name Bomb
@export var explosion_size = 1
@onready var collision_shape_static_body: CollisionShape2D = $StaticBody2D/CollisionShape2D

const CENTRAL_EXPLOSION= preload("res://scenes/central_explosion.tscn")
func _on_cooldown_timer_timeout() -> void:
	var explosion = CENTRAL_EXPLOSION.instantiate()
	explosion.position = position
	explosion.size = explosion_size
	get_tree().root.add_child(explosion)
	queue_free()
	print("BOOOOM!!!")
 
func _on_body_exited(body: Node2D) -> void:
	# Collision only after player exits bomb
	collision_shape_static_body.set_deferred("disabled",false)
