extends Area2D

class_name DirectionalExplosion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func play_animation(animation_name: String):
	animated_sprite_2d.play(animation_name)
	

func _on_body_entered(player: Node2D) -> void:
	if player is Player:
		(player as Player).die()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		(area as Enemy).die()
