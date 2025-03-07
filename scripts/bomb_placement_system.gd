extends Node

class_name BombPlacementSystem

const BOMB_SCENE = preload("res://scenes/bomb.tscn")

const TILE_SIZE = 16

var player: CharacterBody2D = null
var bombs_placed = 0
@export var explosion_size = 1

func _ready() -> void:
	player = get_parent()

func place_bomb():
	if bombs_placed >= player.max_bombs_at_once:
		return
	
	var bomb = BOMB_SCENE.instantiate()
	bomb.explosion_size = explosion_size
	var player_position = player.position
	
	# Encontrado a prueba y error
	const correction_factor = Vector2(16,8)
	# Posicion de la Bomba
	var bomb_position = Vector2(floor((player_position.x + correction_factor.x) / TILE_SIZE) * TILE_SIZE - 8,  \
								floor((player_position.y + correction_factor.y) / TILE_SIZE) * TILE_SIZE - 8 )
									
	bomb.position = bomb_position
	# Agrega a la escena principal de Game, Tal vez hay que modificar para los niveles, ya que los niveles son hijos de Game
	get_tree().root.add_child(bomb)
	bombs_placed += 1
	# Asignamos que cuando la bomba salga del arbol, ejecute dicha funcon on_bomb_exploded
	bomb.tree_exiting.connect(on_bomb_exploded)

func on_bomb_exploded():
	bombs_placed -= 1
