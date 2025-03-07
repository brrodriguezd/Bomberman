extends Node

class_name PowerUpSystem

var player: Player

@onready var animated_sprite : AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var bomb_placement_system : BombPlacementSystem = $"../BombPlacementSystem"
@onready var speedup_timer: Timer = $SpeedUpTimer
@onready var bomb: Bomb = $bomb

func _ready() -> void:
	player = get_parent()
	
func enable_power_up(power_up_type : PowerUps.PowerUps):
	match power_up_type:
		PowerUps.PowerUps.BOMBS:
			print("BOMBS")
			player.max_bombs_at_once += 1
			
		PowerUps.PowerUps.FIRE:
			print("FIRE")
			bomb_placement_system.explosion_size += 1
			
		PowerUps.PowerUps.SPEED_UP:
			print("SPEED UP")
			player.SPEED *= 2.0
			animated_sprite.speed_scale = 2
			speedup_timer.start()
			
		PowerUps.PowerUps.PASS_WALLS:
			print("WALLS")
			player.set_collision_mask_value(1, false)
			speedup_timer.start()


func _on_speed_up_timer_timeout() -> void:
	print("reducing speed")
	player.SPEED /= 2.0
	animated_sprite.speed_scale = 0.5


func _on_pass_walls_timer_timeout() -> void:
	player.set_collision_mask_value(1, true)
