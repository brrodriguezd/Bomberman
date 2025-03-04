extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("Game")
@onready var bomb = load("res://scenes/bomb.tscn")


const SPEED = 100.0
#for platformers
#const JUMP_VELOCITY = -400.0

func bomb_accion():
		var instance = bomb.instantiate()
		instance.spawnPos = global_position
		#to avoid it spawning on top of the player
		instance.zdex = z_index +1
		instance.start()
		main.add_child.call_deferred(instance)

func _physics_process(delta: float) -> void:
	
	if Input.is_key_label_pressed(KEY_0):
		print("pressed")
		bomb_accion()
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
