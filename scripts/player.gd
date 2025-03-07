extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var bomb_placement_system: Node = $BombPlacementSystem

@export var  SPEED = 100.0
@export var max_bombs_at_once = 1

func _physics_process(delta: float) -> void:
	# Ejemplo existente para la tecla 0
	if Input.is_action_just_pressed("place_bomb"):
		bomb_placement_system.place_bomb()
	
	# Obtiene la direccion del movimiento
		# (0,0): No hay input
		# (-1,0): Izquierda
		# (1,0): Derecha
		# (0,-1): Arriba
		# (0,1): Abajo
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Hace espejo del sprite para izquierda
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	# Animaciones
	if direction.y > 0:
		animated_sprite.play("down")
	elif  direction.y < 0:
		animated_sprite.play("up")
	elif direction == Vector2(0,0) or is_on_wall():
		animated_sprite.play("idle")
	elif direction.x != 0:
		animated_sprite.play("run")
	# TODO: Aqui poner animaciones de arriba y abajo, claro despues de ponelas en AnimatedSprite
	
	velocity = direction * SPEED
	move_and_slide()
	
func die():
	animated_sprite.play("die")
	SPEED = Vector2.ZERO
	set_process_input(false)
