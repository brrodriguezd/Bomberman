extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("Game")
@onready var bomb = load("res://scenes/bomb.tscn")

const SPEED = 100.0

func bomb_accion():
	var instance = bomb.instantiate()
	instance.spawnPos = global_position
	# para evitar que aparezca exactamente sobre el jugador
	instance.zdex = z_index + 1
	instance.start()
	main.add_child.call_deferred(instance)

func _physics_process(delta: float) -> void:
	# Ejemplo existente para la tecla 0
	if Input.is_key_label_pressed(KEY_0):
		print("pressed")
		bomb_accion()
		
	# Nueva funcionalidad al presionar la tecla Z
	if Input.is_key_label_pressed(KEY_Z):
		pass
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
