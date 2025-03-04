extends Area2D

var spawnPos : Vector2

var zdex : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnPos
	z_index = zdex

func start():
	print("start")
	$CooldownTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_cooldown_timer_timeout() -> void:
	print("end")
	queue_free()
