extends Area2D

class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 25.0
@export var direction_intersection_change_chance: float = 0.5
@export var change_direction_timeout: float = 3.0
var current_change_direction_timeout: float = 0.0
@onready var enemies: Node = $".."
@onready var timer_enemy: Timer = $TimerEnemy

var direction: Vector2 = Vector2.LEFT
var tile_map: TileMapLayer

const TILE_SIZE = 16
const CORRECTION_FACTOR = Vector2(16, 8)  # Factor de corrección similar al de la bomba

func _ready() -> void:
	tile_map = get_tree().get_first_node_in_group("tilemap")

func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# Ajuste la coordenada ortogonal aplicando el factor de corrección y alineando al tile
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		position.y = floor((position.y + CORRECTION_FACTOR.y) / TILE_SIZE) * TILE_SIZE - 8
	elif direction == Vector2.UP or direction == Vector2.DOWN:
		position.x = floor((position.x + CORRECTION_FACTOR.x) / TILE_SIZE) * TILE_SIZE - 8
	
	# Se asume que las posiciones correctas tienen un offset de 8 (valor constante tras el floor)
	if ((roundi(position.x) - 8) % TILE_SIZE == 0) and ((roundi(position.y) - 8) % TILE_SIZE == 0) and \
		current_change_direction_timeout >= change_direction_timeout and \
		randf() <= direction_intersection_change_chance:
			current_change_direction_timeout = 0
			change_direction_at_intersection(direction)
		
	current_change_direction_timeout += delta

func change_direction_at_intersection(current_direction: Vector2):
	direction = calculate_new_direction(current_direction, true)
	
func calculate_new_direction(current_direction: Vector2, prevent_backtracking: bool) -> Vector2:
	var all_directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var possible_directions: Array[Vector2] = []
	
	all_directions.erase(current_direction)
	
	if prevent_backtracking:
		all_directions.erase(-current_direction)
	
	for direction_to_check in all_directions:
		if not is_direction_blocked(direction_to_check):
			possible_directions.append(direction_to_check)
	
	if possible_directions.size() > 0:
		var new_direction = possible_directions[randi_range(0, possible_directions.size() - 1)]
		change_sprite_direction(new_direction)
		return new_direction
	return current_direction

func is_direction_blocked(direction_to_check: Vector2) -> bool:
	# Se calcula la posición base en el grid usando el mismo factor de corrección que en la bomba
	var base_position = Vector2(
		floor((position.x + CORRECTION_FACTOR.x) / TILE_SIZE) * TILE_SIZE - 8,
		floor((position.y + CORRECTION_FACTOR.y) / TILE_SIZE) * TILE_SIZE - 8)
	# print(base_position)
	var position_to_check = base_position + direction_to_check * TILE_SIZE
	var local_position_to_check = tile_map.to_local(position_to_check)
	var tile_position = tile_map.local_to_map(local_position_to_check)
	var tile_data = tile_map.get_cell_tile_data(tile_position)
	# print(tile_data.get_custom_data("IsSolid"))
	return tile_data.get_custom_data("IsSolid") == true
	
func _on_area_entered(body: Area2D) -> void:
	if (body is PowerUp):
		return
	direction = calculate_new_direction(direction, false)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		(body as Player).die()
	elif body is TileMapLayer:
		direction = calculate_new_direction(direction, false)
	elif body is BrickWall:
		direction = calculate_new_direction(direction, false)
	
func change_sprite_direction(new_direction: Vector2) -> void:
	if new_direction == Vector2.DOWN:
		animated_sprite_2d.play("front")
	elif new_direction == Vector2.UP:
		animated_sprite_2d.play("back")
	elif new_direction == Vector2.LEFT or new_direction == Vector2.RIGHT:
		animated_sprite_2d.play("side")
		animated_sprite_2d.scale.x = sign(-new_direction.x)


func die() -> void:
	animated_sprite_2d.play("die")
	set_physics_process(false)
	speed = 0
	direction = Vector2.ZERO
	set_collision_mask_value(1, false)
	timer_enemy.start()



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "die":
		queue_free()
		print("I died",enemies.get_children())
		
		



func _on_timer_enemy_timeout() -> void:
	print("I died 2",enemies.get_children().size())
	print("I died 3",enemies.get_children().is_empty())
	if enemies.get_children().size() == 1:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	timer_enemy.stop()
