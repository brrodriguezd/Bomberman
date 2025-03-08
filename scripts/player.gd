extends CharacterBody2D

class_name Player
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var bomb_placement_system: Node = $BombPlacementSystem
@onready var power_up_system: Node = $PowerUpSystem
@onready var player: Player = $"."

@export var  SPEED = 100.0
@export var max_bombs_at_once = 1
var isdead = false
var my_number = 0

# Define las acciones por defecto para el jugador 1
var bomb_action: String = "place_bomb"
var move_right_action: String = "move_right"
var move_left_action: String = "move_left"
var move_up_action: String = "move_up"
var move_down_action: String = "move_down"

func _ready() -> void:
	my_number = player.get_meta("player_number")
	# Define las acciones por defecto para el jugador 2
	if my_number == 2:
		bomb_action = "place_bomb_p2"
		move_right_action = "move_right_p2"
		move_left_action = "move_left_p2"
		move_up_action = "move_up_p2"
		move_down_action = "move_down_p2"


func init(player_number: int):
	my_number = player_number

func _physics_process(delta: float) -> void:
	if isdead:
		return
	# Ejemplo para la tecla de colocar bomba (se mantiene is_action_just_pressed)
	if Input.is_action_just_pressed(bomb_action):
		bomb_placement_system.place_bomb()
	
	# Obtiene la dirección verificando cada acción especifica usando is_action_pressed
	var direction = Vector2.ZERO
	if Input.is_action_pressed(move_right_action):
		direction.x += 1
	if Input.is_action_pressed(move_left_action):
		direction.x -= 1
	if Input.is_action_pressed(move_down_action):
		direction.y += 1
	if Input.is_action_pressed(move_up_action):
		direction.y -= 1
	
	# Hace espejo del sprite para izquierda/derecha
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	# Animaciones
	if direction.y > 0:
		animated_sprite.play("down")
	elif direction.y < 0:
		animated_sprite.play("up")
	elif direction == Vector2.ZERO or is_on_wall():
		animated_sprite.play("idle")
	elif direction.x != 0:
		animated_sprite.play("run")
	
	velocity = direction * SPEED
	move_and_slide()
	
func die():
	isdead = true
	set_process_input(false)
	animated_sprite.play("die")
	SPEED = Vector2.ZERO

func enable_power_up(power_up_type: PowerUps.PowerUps):
	power_up_system.enable_power_up(power_up_type)
