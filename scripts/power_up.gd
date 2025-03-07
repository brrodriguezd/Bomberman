extends Area2D

class_name PowerUp

@onready var sprite_2d: Sprite2D = $Sprite2D

var type: PowerUps.PowerUps

func init(power_up_res : PowerUpRes):
	sprite_2d.texture = power_up_res.texture
	type = power_up_res.type


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).enable_power_up(type)
		queue_free()
