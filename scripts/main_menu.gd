extends Control

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_single_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_1_player.tscn")

func _on_multi_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_2_players.tscn")
